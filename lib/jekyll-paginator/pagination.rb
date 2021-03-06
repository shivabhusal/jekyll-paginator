module Jekyll
  module Paginator
    class Pagination < Generator
      # This generator is safe from arbitrary code execution.
      safe true

      # This generator should be passive with regard to its execution
      priority :lowest

      # Generate paginated pages if necessary.
      # Handles pagination for multiple pages
      # site - The Site.
      #
      # Returns nothing.
      def generate(site)
        if Pager.pagination_enabled?(site)
          multiple_pagination = site.config['pagination']

          if multiple_pagination
            multiple_pagination.each do | config |
              paginate = config['paginate']
              per_page = paginate && (paginate['per_page'] || site.config['paginate'])

              site.config['paginate_path'] = paginate['path']
              site.config['paginate']      = per_page if per_page

              handle_pagination(site) if per_page || site.config['paginate']
            end
          else
            handle_pagination(site)
          end
        end
      end
      
      # Generate paginated pages if necessary.
      #
      # site - The Site.
      #
      # Returns nothing.
      def handle_pagination(site)
        if template = self.class.template_page(site)
          paginate(site, template)
        else
          Jekyll.logger.warn "Pagination:", "Pagination is enabled, but I couldn't find " +
          "an index.html page to use as the pagination template. Skipping pagination."
        end
      end
      
      private :handle_pagination
      
      # Paginators the blog's posts. Renders the index.html file into paginated
      # directories, e.g.: page2/index.html, page3/index.html, etc and adds more
      # site-wide data.
      #
      # site - The Site.
      # page - The index.html Page that requires pagination.
      #
      # {"paginator" => { "page" => <Number>,
      #                   "per_page" => <Number>,
      #                   "posts" => [<Post>],
      #                   "total_posts" => <Number>,
      #                   "total_pages" => <Number>,
      #                   "previous_page" => <Number>,
      #                   "next_page" => <Number> }}
      def paginate(site, page)
        all_posts = site.site_payload['site']['posts'].reject { |post| post['hidden'] }
        pages = Pager.calculate_pages(all_posts, site.config['paginate'].to_i)
        (1..pages).each do |num_page|
          pager = Pager.new(site, num_page, all_posts, pages)
          if num_page > 1
            newpage = Page.new(site, site.source, page.dir, page.name)
            newpage.pager = pager
            newpage.dir = Pager.paginate_path(site, num_page)
            site.pages << newpage
          else
            page.pager = pager
          end
        end
      end

      # Static: Fetch the URL of the template page. Used to determine the
      #         path to the first pager in the series.
      #
      # site - the Jekyll::Site object
      #
      # Returns the url of the template page
      def self.first_page_url(site)
        if page = Pagination.template_page(site)
          page.url
        else
          nil
        end
      end

      # Public: Find the Jekyll::Page which will act as the pager template
      #
      # site - the Jekyll::Site object
      #
      # Returns the Jekyll::Page which will act as the pager template
      def self.template_page(site)
        site.pages.select do |page|
          Pager.pagination_candidate?(site.config, page)
        end.sort do |one, two|
          two.path.size <=> one.path.size
        end.first
      end

    end
  end
end
