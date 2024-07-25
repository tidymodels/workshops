function mastodon(args)
    if quarto.doc.isFormat('html') then
        local status_url = pandoc.utils.stringify(args[1])
        print(status_url)
        -- Assemble HTML to be returned
        local html = '<div style="position: relative;"> <iframe src="'.. status_url ..'/embed" class="mastodon-embed" style="max-width: 100%; border: 0;" width="100%" height="500" allowfullscreen="allowfullscreen"></iframe><script src="https://mastodon.social/embed.js" async="async"></script></div> '

	return pandoc.RawInline('html', html)
    else
        return pandoc.Null()
    end
end
