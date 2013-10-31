## GENERAL
By saving the data about supporters, we have following information about them:

id: ID number, more numbers than supporters because non-confirmed supporters are deleted AFAIK
time: Date and time of subscription
firstname: First Name of Supporter
lastname: Last Name of Supporter
email: Email address of supporter
country_code: Two digit country code of supporter (ISO-639-1 as it seems)
secret: unknown, seemes to be a MD5 hash
signed: unused, maybe a option to subscribe for newsletter
confirmed: Date and time of email confirmation
updated: unused AFAICS
ref_url: Referal URL
ref_id: Referal ID (like "mk" for Matthias or "google" for an Google url)
lang: Maybe language of browser?
reminder1: Date and time of 1st reminder mail?
reminder2: Date and time of 2nd reminder mail?
reminder3: Date and time of 3rd reminder mail?
zip: ZIP Code, unused
city: City, unused


## DOWNLOADING
For downloading the supporters file, follow these steps:
1. Modify the file /fsfe-web/trunk/support/export-support-as-csv-with-obscured-url-lkaf9847h59j7f4s5ds.php:
Change: 	//die("This file is for debugging only.");
to: 		die("This file is for debugging only.");

2. Commit the changes, wait for rebuild and open following url:
https://fsfe.org/support/export-support-as-csv-with-obscured-url-lkaf9847h59j7f4s5ds.php
The download should start now. If not, doublecheck step 1 or wait a bit longer (~10 min)

3. After downloading, revert step 1 and add // in front of the debugging file
if not, everybody would be able to download sensitive data.


## IMPORTING
If you want to import this data in CiviCRM, you need to format it first. For example, many names are lower/uppercase only or are empty. The Country Codes are not supported in CiviCRM as well. Additionally, some data is completely useless. If you have another feeling, feel free to change the script.

For this, you can use format-supporters.sh in addition to countries.txt. Just define a file to import (default: supporters.csv), the desired filename at output (default: supporters_format.csv) and the CountryCode-to-Country-Name file (default: countries.txt).

Now execute the shell script in your local terminal:
./format-supporters.sh

After ~5-10 minutes, all entries should be written to the output file. Please do not worry if the output file keeps empty until the end of the script: It writes the data to a temporary file during the execution process.


To understand what the script exactly does, please see the comments in the bash script.