# pdf_page_number
Add page number to existing PDF file

# Prerequisites
	* pdftk
	* mawk

# Inputs
	* PDF file you want to add page numbers.
	* PDF file containing page numbers.

# Usage
	1. Create a pdf file using your favorite document editor containing just the page numbers. Make sure to format it well.
	2. Open a Terminal. Following are the shell commands.
		chmod +x add_page_numbers.sh
		./add_page_numbers.sh pageNumber.pdf orginal.pdf output.pdf