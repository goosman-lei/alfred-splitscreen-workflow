#!/bin/bash
SCRIPT_PATH=$(dirname "$(realpath ${BASH_SOURCE[0]})")
CSV_FNAME="${SCRIPT_PATH}/split-screen.csv"
CSV_TMP_FNAME="${SCRIPT_PATH}/split-screen.csv.tmp"
SCPT_FNAME="${SCRIPT_PATH}/split-screen.scpt"
SCPT_TPL_FNAME="${SCRIPT_PATH}/split-screen.tpl"

if [ "X$1" == "Xshow" ] ; then
awk -F$'\t' -v "showWhere=$2" -v "filterPrefix=$3" -v NLine=$(wc -l "${CSV_FNAME}" | head -n 1 | awk '{print $1}') '
BEGIN {
	if (showWhere != "other" && showWhere != "main" && showWhere != "dual") {
		showWhere = "current"
	}
	printf("{\"items\": [\n");
}
NF == 5 && NR < NLine {
	if (length(filterPrefix) == 0 || index($1, filterPrefix) > 0) {
		printf("\t{\"arg\": [\"predefined\", \"%s\", \"%s\"], \"title\": \"%s\", \"subtitle\": \"%s\"},\n", showWhere, $1, $1, $1);
	}
}
NR == NLine {
	if (length(filterPrefix) == 0 || index($1, filterPrefix) > 0) {
		printf("\t{\"arg\": [\"predefined\", \"%s\", \"%s\"], \"title\": \"%s\", \"subtitle\": \"%s\"},\n", showWhere, $1, $1, $1);
	}
}
END {
	printf("]}\n");
}
' "${CSV_FNAME}" 
	exit
fi

[ -f "${CSV_FNAME}" ] || touch "${CSV_FNAME}"

awk -F$'\t' -v "input_name=$1" -v "input_x=$2" -v "input_y=$3" -v "input_w=$4" -v "input_h=$5" '
NF == 5 && !AlreadyPrinted[$1] {
	if ($1 == input_name) {
		printf("%s\t%s\t%s\t%s\t%s\n", input_name, input_x, input_y, input_w, input_h);
	} else {
		printf("%s\n", $0);
	}
	AlreadyPrinted[$1] = 1
}
' "${CSV_FNAME}" > "${CSV_TMP_FNAME}"
mv "${SCRIPT_PATH}/split-screen.csv.tmp" "${SCRIPT_PATH}/split-screen.csv"

awk -F$'\t' '
Begin {
	NumberOfRecord = 0
}
NF == 5 && NR == FNR{
	NumberOfRecord ++
	Infos_name[NumberOfRecord] = $1;
	Infos_x[NumberOfRecord] = $2;
	Infos_y[NumberOfRecord] = $3;
	Infos_w[NumberOfRecord] = $4;
	Infos_h[NumberOfRecord] = $5;
}
NR > FNR {
	if (!print_after_replace) {
		if ($0 != "----TPL_REPLACE_WITH_CONFIG") {
			print $0
		} else {
			print_after_replace = 1
			for (Idx = 1; Idx <= NumberOfRecord; Idx ++) {
				if (Idx == 1) {
					printf("    if positionType as string is equal to \"%s\" then\n", Infos_name[Idx]);
					printf("        set {percentX, percentY, percentW, percentH} to {%0.2f, %0.2f, %0.2f, %0.2f}\n", Infos_x[Idx], Infos_y[Idx], Infos_w[Idx], Infos_h[Idx]);
				} else if (Idx < NumberOfRecord) {
					printf("    else if positionType as string is equal to \"%s\" then\n", Infos_name[Idx]);
					printf("        set {percentX, percentY, percentW, percentH} to {%0.2f, %0.2f, %0.2f, %0.2f}\n", Infos_x[Idx], Infos_y[Idx], Infos_w[Idx], Infos_h[Idx]);
				} else {
					printf("    else if positionType as string is equal to \"%s\" then\n", Infos_name[Idx]);
					printf("        set {percentX, percentY, percentW, percentH} to {%0.2f, %0.2f, %0.2f, %0.2f}\n", Infos_x[Idx], Infos_y[Idx], Infos_w[Idx], Infos_h[Idx]);
					printf("    end if\n");
				}
			}
		}
	} else if (print_after_replace) {
		print $0
	}
}
' "${CSV_FNAME}" "${SCPT_TPL_FNAME}" > "${SCPT_FNAME}"
