function parse_line(line,   ret) {
	if (line ~ /^#[[:space:]]+[^[:space:]].*[^[:space:]][[:space:]]*$/) {
		ret = ret tag("h1", parse_line(gensub(/^#[[:space:]]+([^[:space:]].*[^[:space:]])[[:space:]]*$/, "\\1", "g", line)))
	} else if (line ~ /^##[[:space:]]+[^[:space:]].*[^[:space:]][[:space:]]*$/) {
		ret = ret tag("h2", parse_line(gensub(/^##[[:space:]]+([^[:space:]].*[^[:space:]])[[:space:]]*$/, "\\1", "g", line)))
	} else if (line ~ /^###[[:space:]]+[^[:space:]].*[^[:space:]][[:space:]]*$/) {
		ret = ret tag("h3", parse_line(gensub(/^###[[:space:]]+([^[:space:]].*[^[:space:]])[[:space:]]*$/, "\\1", "g", line)))
	} else if (line ~ /^####[[:space:]]+[^[:space:]].*[^[:space:]][[:space:]]*$/) {
		ret = ret tag("h4", parse_line(gensub(/^####[[:space:]]+([^[:space:]].*[^[:space:]])[[:space:]]*$/, "\\1", "g", line)))
	} else if (line ~ /^#####[[:space:]]+[^[:space:]].*[^[:space:]][[:space:]]*$/) {
		ret = ret tag("h5", parse_line(gensub(/^#####[[:space:]]+([^[:space:]].*[^[:space:]])[[:space:]]*$/, "\\1", "g", line)))
	} else if (line ~ /^######[[:space:]]+[^[:space:]].*[^[:space:]][[:space:]]*$/) {
		ret = ret tag("h6", parse_line(gensub(/^######[[:space:]]+([^[:space:]].*[^[:space:]])[[:space:]]*$/, "\\1", "g", line)))
	} else if (line ~ /\*\*[^[:space:]].*[^[:space:]]\*\*/) {
		ret = ret parse_line(gensub(/\*\*([^[:space:]].*[^[:space:]])\*\*/, "<strong>\\1</strong>", "g", line))
	} else if (line ~ /__[^[:space:]].*[^[:space:]]__/) {
		ret = ret parse_line(gensub(/__([^[:space:]].*[^[:space:]])__/, "<strong>\\1</strong>", "g", line))
	} else if (line ~ /\*[^[:space:]*].*[^[:space:]*]\*/) {
		ret = ret parse_line(gensub(/\*([^[:space:]*].*[^[:space:]*])\*/, "<em>\\1</em>", "g", line))
	} else if (line ~ /_[^[:space:]_].*[^[:space:]_]_/) {
		ret = ret parse_line(gensub(/_([^[:space:]_].*[^[:space:]_])_/, "<em>\\1</em>", "g", line))
	} else if (line ~ /\[.+\]\(.+\)/) {
		ret = ret gensub(/\[(.+)\]\((.+)\)/, "<a href=\"\\2\">\\1</a>", "g", line)
	} else {
		gsub(/  $/, "<br />", line)
		ret = ret line
	}
	return ret
}

function tag(stag, body) {
	return "<" stag ">" body "</" stag ">"
}

function parse_para(para,   lines, ret) {
	max_idx = split(para, lines)
	for (i = 1; i <= max_idx; i++) {
		if (lines[i + 1] ~ /^==+/) {
			ret = ret tag("h1", parse_line(lines[i]))
		} else if (lines[i + 1] ~ /^--+/) {
			ret = ret tag("h2", parse_line(lines[i]))
		} else if (lines[i] ~ /^==+/ || lines[i] ~ /^--+/) {
			ret = ret "<hr />"
		}else if (lines[i] ~ /^[[:space:]]*>/) {
			ret = ret "<blockquote>"
			for (; lines[i] ~ /^[[:space:]]*>/; i++) {
				ret = ret parse_line(gensub(/^[[:space:]]*>(.*)/, "\\1", "g", lines[i]))
			}
			i--
			ret = ret "</blockquote>"
		} else if (lines[i] ~ /^[[:space:]]*(\*|-)[[:space:]]+[^[:space:]].*/) {
			ret = ret "<ul>"
			for (; lines[i] ~ /^[[:space:]]*(\*|-)/; i++) {
				ret = ret tag("li", parse_line(gensub(/^[[:space:]]*(\*|-)[[:space:]]+([^[:space:]].*)/, "\\2", "g", lines[i])))
			}
			i--
			ret = ret "</ul>"
		} else if (lines[i] ~ /^[[:space:]]*[[:digit:]]+\.[[:space:]]+[^[:space:]].*/) {
			ret = ret "<ol>"
			for (; lines[i] ~ /^[[:space:]]*[[:digit:]]+\.[[:space:]]+[^[:space:]].*/; i++) {
				ret = ret tag("li", parse_line(gensub(/^[[:space:]]*[[:digit:]]+\.[[:space:]]+([^[:space:]].*)/, "\\1", "g", lines[i])))
			}
			i--
			ret = ret "</ol>"
		} else if (lines[i] ~ /^```/) {
			ret = ret "<pre><code>"
			for (i++; lines[i] !~ /^```/; i++) {
				gsub(/>/, "\\&gt;", lines[i])
				gsub(/</, "\\&lt;", lines[i])
				ret = ret  lines[i] "\n"
			}
			ret = ret "</code></pre>"
		} else {
			ret = ret parse_line(lines[i])
		}
	}
	return ret
}

BEGIN {
	RS = ""
	FS = "\n"
}

{
	body = body tag("p", parse_para($0))

}

END {
	print "<!DOCTYPE html>" tag("html", tag("head","<meta charset=\"UTF-8\">") tag("body", body))
}
