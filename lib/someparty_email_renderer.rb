require 'middleman-core/renderers/redcarpet'

# Extends the Redcarpet Markdown parser to generate clean email markup
# removing anything that's not suited for email.
class SomePartyEmailRenderer < Middleman::Renderers::MiddlemanRedcarpetHTML

  def block_html(raw_html)
    doc = Nokogiri::HTML(raw_html)
    format('')
  end

  def block_quote(text)
    format('<blockquote>%s</blockquote>', text)
  end

  def header(text, header_level)
    format('<h%s>%s</h%s>', header_level,
           text, header_level)
  end

  def hrule
    '<hr/>'
  end

  def link(link, title, content)

    # Centered, bold media links are indicated by a title that starts with "#"

    featured_media = false

    if title
      if title.start_with?('#')
        featured_media = true
        if title.length > 1
          title[0] = ''
        else
          title = nil
        end
      end
    end

    if featured_media
      link_string = link.dup
      link_string << %("#{title}") if title && !title.empty? && title != alt_text
      "<div style='text-align: center;'><strong><a href='#{link_string}' target='_blank'>#{content}</a></strong></div>"
    else
      attributes = { title: title, target: '_blank' }
      attributes.merge!(@local_options[:link_attributes]) if @local_options[:link_attributes]
      scope.link_to(content, link, attributes)
    end
  end

  def list(content, list_type)
    case list_type
    when :ordered
      format("<ol>%s</ol>", content)
    when :unordered
      format("<ul>%s</ul>", content)
    end
  end

  def paragraph(text)
    format("<p>%s</p>", text)
  end

end
