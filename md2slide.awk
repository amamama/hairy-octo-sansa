function parse_line(line,   ret) {
	if (line ~ /^==+/ || lines ~ /^--+/) {
		if (line ~ /^==+/ && (slide == "hamaji" || slide == "shinh" || slide == "simple" || slide == "s")) {
		} else {
			ret = ret "<hr />"
		}
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

function tag(stag, body, opt) {
	return "<" stag " " opt ">" body "</" stag ">"
}

function parse_para(para,   lines, ispara, ret, begp, endp) {
	max_idx = split(para, lines)
	begp = ""
	endp = ""
	ispara = 0
	for (i = 1; i <= max_idx; i++) {
		if (lines[i + 1] ~ /^==+/) {
			if (slide == "hamaji" || slide == "shinh" || slide == "simple" || slide == "s") {
				headline = tag("h1", parse_line(lines[i])) "<hr />"
				i++
			} else {
				ret = ret endp tag("h1", parse_line(lines[i]))
				ispara = 0
				endp = ""
			}
		} else if (lines[i + 1] ~ /^--+/) {
			if (slide == "hamaji" || slide == "shinh" || slide == "simple" || slide == "s") {
				ret = ret endp parse_line(lines[i])
				ispara = 0
				endp = ""
			} else {
				ret = ret endp tag("h2", parse_line(lines[i]))
				ispara = 0
				endp = ""
			}
		} else if (lines[i] ~ /^#[[:space:]]+[^[:space:]].*[^[:space:]][[:space:]]*$/) {
			ret = ret endp tag("h1", parse_line(gensub(/^#[[:space:]]+([^[:space:]].*[^[:space:]])[[:space:]]*$/, "\\1", "g", lines[i])))
			ispara = 0
			endp = ""
		} else if (lines[i] ~ /^##[[:space:]]+[^[:space:]].*[^[:space:]][[:space:]]*$/) {
			ret = ret endp tag("h2", parse_line(gensub(/^##[[:space:]]+([^[:space:]].*[^[:space:]])[[:space:]]*$/, "\\1", "g", lines[i])))
			ispara = 0
			endp = ""
		} else if (lines[i] ~ /^###[[:space:]]+[^[:space:]].*[^[:space:]][[:space:]]*$/) {
			ret = ret endp tag("h3", parse_line(gensub(/^###[[:space:]]+([^[:space:]].*[^[:space:]])[[:space:]]*$/, "\\1", "g", lines[i])))
			ispara = 0
			endp = ""
		} else if (lines[i] ~ /^####[[:space:]]+[^[:space:]].*[^[:space:]][[:space:]]*$/) {
			ret = ret endp tag("h4", parse_line(gensub(/^####[[:space:]]+([^[:space:]].*[^[:space:]])[[:space:]]*$/, "\\1", "g", lines[i])))
			ispara = 0
			endp = ""
		} else if (lines[i] ~ /^#####[[:space:]]+[^[:space:]].*[^[:space:]][[:space:]]*$/) {
			ret = ret endp tag("h5", parse_line(gensub(/^#####[[:space:]]+([^[:space:]].*[^[:space:]])[[:space:]]*$/, "\\1", "g", lines[i])))
			ispara = 0
			endp = ""
		} else if (lines[i] ~ /^######[[:space:]]+[^[:space:]].*[^[:space:]][[:space:]]*$/) {
			ret = ret endp tag("h6", parse_line(gensub(/^######[[:space:]]+([^[:space:]].*[^[:space:]])[[:space:]]*$/, "\\1", "g", lines[i])))
			ispara = 0
			endp = ""
		}else if (lines[i] ~ /^[[:space:]]*>/) {
			ret = ret endp "<blockquote>"
			for (; lines[i] ~ /^[[:space:]]*>/; i++) {
				ret = ret parse_line(gensub(/^[[:space:]]*>(.*)/, "\\1", "g", lines[i]))
			}
			i--
			ret = ret "</blockquote>"
			ispara = 0
			endp = ""
		} else if (lines[i] ~ /^[[:space:]]*(\*|-)[[:space:]]+[^[:space:]].*/) {
			ret = ret endp "<ul>"
			for (; lines[i] ~ /^[[:space:]]*(\*|-)/; i++) {
				ret = ret tag("li", parse_line(gensub(/^[[:space:]]*(\*|-)[[:space:]]+([^[:space:]].*)/, "\\2", "g", lines[i])))
			}
			i--
			ret = ret "</ul>"
			ispara = 0
			endp = ""
		} else if (lines[i] ~ /^[[:space:]]*[[:digit:]]+\.[[:space:]]+[^[:space:]].*/) {
			ret = ret endp "<ol>"
			for (; lines[i] ~ /^[[:space:]]*[[:digit:]]+\.[[:space:]]+[^[:space:]].*/; i++) {
				ret = ret tag("li", parse_line(gensub(/^[[:space:]]*[[:digit:]]+\.[[:space:]]+([^[:space:]].*)/, "\\1", "g", lines[i])))
			}
			i--
			ret = ret "</ol>"
			ispara = 0
			endp = ""
		} else if (lines[i] ~ /^```/) {
			ret = ret endp "<pre><code>"
			for (i++; lines[i] !~ /^```/; i++) {
				gsub(/>/, "\\&gt;", lines[i])
				gsub(/</, "\\&lt;", lines[i])
				ret = ret  lines[i] "\n"
			}
			ret = ret "</code></pre>"
			ispara = 0
			endp = ""
		} else {
			if (ispara != 0) {
				ret = ret parse_line(lines[i])
			} else {
			ret = ret "<p>" parse_line(lines[i])
			ispara = 1
			endp = "</p>"
			}
		}
	}
	if (ispara != 0) {
		ret = ret "</p>"
		ispara = 0
		endp = ""
	}
	return ret
}

BEGIN {
	RS = ""
	FS = "\n"
	slide = "simple"
	filename = gensub(/(.*)\.md/, "\\1", "g", ARGV[1])
	"mkdir -p " filename | getline
	print ARGV[1] "-> ./" filename "/" filename ".html"
}

{
	if (slide == "hamaji" || slide == "shinh" || slide == "simple" || slide == "s") {
		body = parse_para($0)
		print "<!DOCTYPE html>" tag("html", tag("head","<meta charset=\"UTF-8\">") tag("body",
				tag("a", "&lt;", "href = \"./" filename NR-1 ".html\"") \
				tag("a", "&gt;", "href = \"./" filename NR+1 ".html\"") \
				tag("section", headline body) \
				)) >  "./" filename "/" filename NR ".html"
	} else {
		body = body tag("p", parse_para($0))
	}

}

END {
}
