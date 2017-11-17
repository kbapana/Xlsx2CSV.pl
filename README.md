# Xlsx2CSV.pl
Having created this code it has the ability to convert the file format from .Xlsx to .CSV.
When tried converting multiple files it is cutting of in the middle and is converting only one file at a time.
use Text::Iconv;
my $converter = Text::Iconv -> new ("utf-8", "windows-1251");

# Text::Iconv is not really required.
# This can be any object with the convert method. Or nothing.

use Spreadsheet::XLSX;
@files = <*.xlsx>; 

open (FILE, ">CIQ-Vendor Consolidate.CSV.csv");
my $colmin=0;
my $colmax=0;

foreach $file (@files) {
my $excel = Spreadsheet::XLSX -> new ($file, $converter);

foreach my $sheet (@{$excel -> {Worksheet}}) {
	printf("Sheet: %s\n", $sheet->{Name});

	$sheet -> {MaxRow} ||= $sheet -> {MinRow};

		foreach my $row ($sheet -> {MinRow} .. $sheet -> {MaxRow}) {
			$sheet -> {MaxCol} ||= $sheet -> {MinCol};
			
			foreach my $col ($sheet -> {MinCol} .. $sheet -> {MaxCol}) {
				my $cell = $sheet -> {Cells} [$row] [$col];
				printf("col number, Maxcol: %d %d", $col, $sheet -> {MaxCol});
				if ($cell) {
					if ( $col == $sheet -> {MaxCol} ) {
					#	if ( $col == 3 ) {
					    print FILE $cell -> {Val};
					    } else {
					    print FILE $cell -> {Val}.",";
					    }
				}
				else {
					print(FILE "NA");	
				}
			}
			print FILE "\n";
		}
}
close(FILE);
}
