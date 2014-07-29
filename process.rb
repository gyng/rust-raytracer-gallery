require 'cgi'
require 'json'

image_directory = "./i/"

exhibits = JSON.parse(File.read('./exhibits.json'), symbolize_names: true)

exhibit_template_image = '

  <div class="exhibit">
    <a class="anchor" href="#{{anchor}}" id="{{anchor}}" title="Link">&sect;</a><br>
    <a href="{{src}}">
      <img src="{{src}}">
    </a>

    <div class="specs">
      <div class="exhibit-title">{{title}}</div>
      <div class="exhibit-caption">{{caption}}</div>
    </div>
  </div>'

exhibit_template_video = '
  <div class="exhibit" id={{anchor}}>
    <a class="anchor" href="#{{anchor}}" id="{{anchor}}" title="Link">&sect;</a><br>
    <video src="{{src}}" autoplay loop></video>

    <div class="specs">
      <div class="exhibit-title">{{title}}</div>
      <div class="exhibit-caption">{{caption}}</div>
    </div>
  </div>'


File.open('./preindex.html', 'r') do |f|
  i = 0
  exhibits_html = ""

  exhibits.each do |exhibit|
    template = case exhibit[:type]
    when 'image'; exhibit_template_image.dup
    when 'video'; exhibit_template_video.dup
    end

    template.gsub!("{{src}}",     "#{image_directory}#{exhibit[:src]}")
    template.gsub!("{{title}}",   exhibit[:title])
    template.gsub!("{{caption}}", exhibit[:caption])
    template.gsub!("{{anchor}}",  "exhibit-#{i}")

    exhibits_html = exhibits_html + template

    i += 1
  end

  File.write('./index.html', f.read.gsub("{{exhibits}}", exhibits_html))
end
