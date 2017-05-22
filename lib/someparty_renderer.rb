require 'middleman-core/renderers/redcarpet'

# Extends the Redcarpet Markdown parser to generate Tachyons style CSS markup
class SomePartyRenderer < Middleman::Renderers::MiddlemanRedcarpetHTML

  def block_html(raw_html)
    doc = Nokogiri::HTML(raw_html)
    if raw_html.include? 'youtube'
      doc.css('iframe').add_class('aspect-ratio--object')
      format("<div class='overflow-hidden aspect-ratio aspect-ratio--16x9'>%s</div>",
             doc.to_html)
    elsif raw_html.include? 'instagram'
      doc.css('blockquote').add_class('dib tl')
      format("<div class='center tc'><div class='dib tl w-100 maxread'>%s</div></div>", doc.to_html)
    else
      format("<div class='center'>%s</div>", doc.to_html)
    end
  end

  def block_quote(text)
    format('<blockquote class="maxquote center pl4 black-60 bl bw2 b--red">%s</blockquote>', text)
  end

  def header(text, header_level)
    format('<h%s class="maxread center">%s</h%s>', header_level,
           text, header_level)
  end

  def hrule
    "<hr class='bg-black-30 mt4 mb6 maxread bn hr-1'/>"
  end

  def link(link, title, content)
    if !@local_options[:no_links]
      attributes = { title: title, class: 'black no-underline fw4 bb b--black', target: '_blank' }
      attributes.merge!(@local_options[:link_attributes]) if @local_options[:link_attributes]
      scope.link_to(content, link, attributes)
    else
      link_string = link.dup
      link_string << %("#{title}") if title && !title.empty? && title != alt_text
      "[#{content}](#{link_string})"
    end
  end

  def list(content, list_type)
    case list_type
    when :ordered
      format("<ol class='maxread center'>%s</ol>", content)
    when :unordered
      format("<ul class='maxread center'>%s</ul>", content)
    end
  end

  def paragraph(text)
    if text.include? '<img'
      format("<p class='tc center'>%s</p>", text)
    else
      format("<p class='maxread center'>%s</p>", text)
    end
  end

end
