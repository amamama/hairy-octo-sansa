function parse_line(line,   ret) {
	if (line ~ /^#[[:space:]]*[^[:space:]].*[^[:space:]][[:space:]]*$/) {
		ret = ret tag("h1", parse_line(gensub(/^#[[:space:]]*([^[:space:]].*[^[:space:]])[[:space:]]*$/, "\\1", "g", line)));

	} else if (line ~ /^##[[:space:]]*[^[:space:]].*[^[:space:]][[:space:]]*$/) {
		ret = ret tag("h2", parse_line(gensub(/^##[[:space:]]*([^[:space:]].*[^[:space:]])[[:space:]]*$/, "\\1", "g", line)));
	} else if (line ~ /^###[[:space:]]*[^[:space:]].*[^[:space:]][[:space:]]*$/) {
		ret = ret tag("h3", parse_line(gensub(/^###[[:space:]]*([^[:space:]].*[^[:space:]])[[:space:]]*$/, "\\1", "g", line)));
	} else if (line ~ /^####[[:space:]]*[^[:space:]].*[^[:space:]][[:space:]]*$/) {
		ret = ret tag("h4", parse_line(gensub(/^####[[:space:]]*([^[:space:]].*[^[:space:]])[[:space:]]*$/, "\\1", "g", line)));
	} else if (line ~ /^#####[[:space:]]*[^[:space:]].*[^[:space:]][[:space:]]*$/) {
		ret = ret tag("h5", parse_line(gensub(/^#####[[:space:]]*([^[:space:]].*[^[:space:]])[[:space:]]*$/, "\\1", "g", line)));
	} else if (line ~ /^######[[:space:]]*[^[:space:]].*[^[:space:]][[:space:]]*$/) {
		ret = ret tag("h6", parse_line(gensub(/^######[[:space:]]*([^[:space:]].*[^[:space:]])[[:space:]]*$/, "\\1", "g", line)));
	} else if (line ~ /\*\*[^[:space:]].+[^[:space:]]\*\*/) {
		ret = ret parse_line(gensub(/\*\*([^[:space:]].+[^[:space:]])\*\*/, "<strong>\\1</strong>", "g", line));
	} else if (line ~ /__[^[:space:]].+[^[:space:]]__/) {
		ret = ret parse_line(gensub(/__([^[:space:]].+[^[:space:]])__/, "<strong>\\1</strong>", "g", line));
	} else if (line ~ /\*[^[:space:]*].+[^[:space:]*]\*/) {
		ret = ret parse_line(gensub(/\*([^[:space:]*].+[^[:space:]*])\*/, "<em>\\1</em>", "g", line));
	} else if (line ~ /_[^[:space:]_].+[^[:space:]_]_/) {
		ret = ret parse_line(gensub(/_([^[:space:]_].+[^[:space:]_])_/, "<em>\\1</em>", "g", line));
	} else if (line ~ /\[.+\]\(.+\)/) {
		ret = ret gensub(/\[(.+)\]\((.+)\)/, "<a href=\"\\2\">\\1</a>", "g", line);
	} else {
		gsub(/  $/, "<br />", line);
		ret = ret line;
	}
	return ret;
}

function tag(stag, body) {
	return "<" stag ">" body "</" stag ">";
}

function parse_para(para,   lines, ret) {
	max_idx = split(para, lines);
	ret = ret "<p>";
	for (i = 1; i <= max_idx; i++) {
		if (lines[i + 1] ~ /^=+/) {
			ret = ret tag("h1", parse_line(lines[i]));
		} else if (lines[i + 1] ~ /^-+/) {
			ret = ret tag("h2", parse_line(lines[i]));
		} else if (lines[i] ~ /^=+/ || lines[i] ~ /^-+/) {
			ret = ret "<hr />";
		}else if (lines[i] ~ /^[[:space:]]*>/) {
			ret = ret "<blockquote>"
			for (; lines[i] ~ /^[[:space:]]*>/; i++) {
				ret = ret parse_line(gensub(/^[[:space:]]*>(.*)/, "\\1", "g", lines[i]));
			}
			ret = ret "</blockquote>";
		} else if (lines[i] ~ /^[[:space:]]*(\*|-)[[:space:]]+[^[:space:]].*/) {
			ret = ret "<li>";
			for (; lines[i] ~ /^[[:space:]]*(\*|-)/; i++) {
				ret = ret tag("ul", parse_line(gensub(/^[[:space:]]*(\*|-)[[:space:]]+([^[:space:]].*)/, "\\2", "g", lines[i])));
			}
			ret = ret "</li>";
		} else if (lines[i] ~ /^[[:space:]]*[[:digit:]]+[[:space:]]+[^[:space:]].*/) {
			ret = ret "<li>";
			for (; lines[i] ~ /^[[:space:]]*[[:digit:]]+[[:space:]]+[^[:space:]].*/; i++) {
				ret = ret tag("ul", parse_line(gensub(/^[[:space:]]*[[:digit:]]+[[:space:]]+([^[:space:]].*)/, "\\1", "g", lines[i])));
			}
			ret = ret "</li>";
		} else if (lines[i] ~ /^```/) {
			ret = ret "<code>";
			for (; lines[i] !~ /^```/; i++) {
				ret lines[i] "<br />";
			}
			ret = ret "</code>";
		} else {
			ret = ret parse_line(lines[i]);
		}
	}
	ret = ret "</p>";
	return ret;
}

BEGIN {
	RS = "";
	FS = "\n";
	print "<!DOCTYPE html>""<html>"
	print tag("head","<meta charset=\"UTF-8\">");
	print "<body>"
}

{
	print parse_para($0);

}

END {
	print "</body>"
	print "</html>"
}
