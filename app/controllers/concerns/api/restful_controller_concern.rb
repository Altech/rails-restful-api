module Api::RestfulControllerConcern
  extend ActiveSupport::Concern

  included do
    include InstanceMethods
  end

  module InstanceMethods
    # called before action
    #--------------------------------------------------

    def debug_mode?
      params[:debug].to_b && !Rails.env.production?
    end

    def prepare_restful_params
      @fields, @include = prepare_for_fields_and_include(
        fields_param: process_param_as_array(params[:fields]),
        include_param: process_param_as_array(params[:include]),
      ) unless debug_mode?

      @sort = prepare_for_sort(
        sort_param: process_param_as_array(params[:sort]),
      )
    end

    def prepare_for_fields_and_include(fields_param: [], include_param: [])
      fields_param = fields_param.map{ |v| v.split('.').map(&:to_sym) }
      include_param = include_param.map{ |v| v.split('.').map(&:to_sym) }

      include = include_param.sort_by(&:size).inject({}) do |include, associations|
        hash = include
        associations.each_with_index do |association, i|
          if i == associations.size - 1
            hash[association] = {}
          else
            hash = hash[association]
            if hash.nil?
              raise Api::ImplicitIncludeError.new(associations[0..i])
            end
          end
        end
        include
      end

      toplevel = fields_param.select { |f| f.size == 1 }.flatten
      nested   = fields_param.select { |f| f.size > 1 }

      fields = [:id] + toplevel

      nested.each do |f|
        associations, field = f[0..-2], f[-1]

        hash = include.dig(*associations)
        if hash.nil?
          raise Api::UnincludedFieldError.new(field, associations)
        end
        hash[:only] ||= []
        hash[:only] << f.last
      end

      return fields, include
    end

    def prepare_for_sort(sort_param: [])
      if sort_param.present?
        sort_param
      else
        ['-id']
      end
    end

    # To accept both comma-separated array and brackets array.
    # And treat nil as empty array.
    #
    # comma-separated array: fields=foo,bar,baz
    # brackets array:        fields[]=foo&fields[]=bar&fields[]=baz
    def process_param_as_array(param)
      case param
      when nil
        []
      when Array
        param
      when String
        param.split(',')
      end      
    end

    Sorter = Struct.new(:order, :joins)

    def sort_param(name, order:, joins: nil)
      @sorters ||= {}
      @sorters[name.to_s] = Sorter.new(order, joins)
    end

    # called in action
    #--------------------------------------------------

    def setup_collection(collection, pagination: true, sort: true)
      collection = setup_sort(collection) if sort
      collection = setup_pagination(collection) if collection
      collection
    end

    DEFAULT_PER_PAGE = 10

    def setup_pagination(rel)
      paginated = rel.page(params[:page]).per(params[:per_page] || DEFAULT_PER_PAGE)
      response.header['X-List-CurrentPage'] = paginated.current_page.to_s
      if params[:page_count].to_b
        response.header['X-List-TotalCount']  = paginated.total_count.to_s
        response.header['X-List-NumPages']    = paginated.num_pages.to_s
        response.header['X-List-IsFirstPage'] = paginated.first_page?.to_s
        response.header['X-List-IsLastPage']  = paginated.last_page?.to_s
      end
      paginated
    end

    def setup_sort(rel)
      @sorters ||= {}
      default_sortable_params = rel.columns.map(&:name).product(['+', '-']).map {|column, sign| sign + column }
      sortable_params = default_sortable_params + @sorters.keys
      if @sort.any? { |sort| !sort.in?(sortable_params) }
        raise Api::SortPermissionError.new(@sort, sortable_params)
      end

      @sort.inject(rel) do |rel, name|
        if @sorters[name]
          sorter = @sorters[name]
          rel.joins(sorter.joins).order(sorter.order)
        else
          name =~ /^([-\+])(.+)$/
          column, sign = $2 , $1
          type = sign == '+' ? 'ASC' : 'DESC'
          rel.order("#{column} #{type}")
        end
      end
    end
  end
end
