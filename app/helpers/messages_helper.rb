module MessagesHelper
  def without_list_prefix(subject)
    subject.sub(/^\[.+?\]\s*/, '')
  end

  MARGIN = 50
  def search_snippet(body, keyword)
    snippet = ''

    offset = 0
    while (i = body.index(keyword, offset))
      start = [i - MARGIN, offset].max
      len = keyword.length + MARGIN
      snippet += body[start, len]
      offset = start + len
    end

    if snippet.empty?
      return body[0, MARGIN * 2]
    else
      snippet
    end
  end
end
