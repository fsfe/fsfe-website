#!/usr/bin/python -u
# -*- coding: utf-8 -*-
# TODO: -u does not seem to have any effect

"""
This script does mass mailing using your Google account to avoid being blacklisted.
Please only send proper mass mails, like press releases and not spam.

Usage: 
  massmailing.py  <username@gmail.com>  <message file txt>  <recipients list csv>

The script must be called with exactly these parameters, no less nor more.

Before execution the script asks for you password interactively.
"""

import sys, getpass, csv, time, smtplib
import textwrap
from email.mime.text import MIMEText
from email.header import Header

def main():
	if len(sys.argv) != 4:
		print __doc__
		sys.exit(0)
	else:
		# Open connection
		username = sys.argv[1]
		password = getpass.unix_getpass("Enter password for account " + username + ": ")
		server = smtplib.SMTP('smtp.gmail.com:587')
		server.starttls()
		print "Authenticating " + username 
		server.login(username,password)
		print "Connection opened."

		# Read each line fron recipients and send mail
		messagefilename = sys.argv[2]
		print "Opening " + messagefilename + ".py"
		msg = __import__(messagefilename)
		addressfilename = sys.argv[3]
		print "Opening " + addressfilename
		addresses = csv.reader(open(addressfilename, 'r'))
		counter = 0
		
		# Now take a pause to send one message to self and check everything is OK
		toaddr = msg.fromaddr
		toname = "Massmailer"
		msg.message_body = ""
		lines = msg.message_body_unwrapped.split("\n")
		
		for line in lines:
			if len(line) > 78:
				w = textwrap.TextWrapper(width=78, break_long_words=False)
				line = '\n'.join(w.wrap(line))
			msg.message_body += line + "\n"
		
		#msg.message_body = textwrap.fill(msg.message_body_unwrapped, 75, break_long_words=False, replace_whitespace=False)
		# withouth replace_whitespace entire message is reflowed and old line breaks forgotten
		# with it extra line breaks are added at odd places
		massmail(server, msg.fromname, msg.fromaddr, msg.subject, msg.message_body, toaddr, toname)
		print "A test message was sent. Check that it is OK."
		check = "empty"
		while not check in ['y','n']:
			check = (raw_input("Can we continue with the mass mailing? (y/n) ")).lower()[0]
		if check == "n":
			print("Aborting...")
			server.quit() # Maybe it closes automatically, but close it to be sure
			sys.exit(0)
		
		# OK, start sending
		for row in addresses:
			if not row:
				continue
			if row[0]:
				firstname = row[0]
			if row[1]:
				lastname = row[1]
			else:
				firstname = ""
				lastname = ""
			
			toname = firstname + " " + lastname
			toaddr = row[2]
			sys.stdout.flush()
			
			# Send mail
			massmail(server, msg.fromname, msg.fromaddr, msg.subject, msg.message_body, toaddr, toname)
			
			# Wait before sending next
			delay = 3
			for i in range(delay):
				countertext = str(i) + "/" + str(delay) + "s until next"
				sys.stdout.write(countertext + '\x08'*len(countertext))
				sys.stdout.flush()
				time.sleep(1)
			counter += 1
		
		# Finally, close the connection
		print str(counter) + " mails sent!       " 
		# extra space at the end to overwrite seconds counter
		server.quit()
		print "Connection closed."

def massmail(server, fromname, fromaddr, subject, message_body, toaddr, toname):
	print "Sending to " + toname,
	print "<" + toaddr + ">",
	
	text = message_body
	# no wordwrap, copy-pasting text from press release to article easier without
	# text = textwrap.fill(text, 75)
	
	msg = MIMEText(text, 'plain', 'utf-8')
	msg['From'] = str(Header(fromname, 'utf-8')) + ' <' + str(fromaddr) + '>'
	if toname:
		msg['To'] = str(Header(toname, 'utf-8')) + ' <' + str(toaddr) + '>'
	else:
		msg['To'] = toaddr
	
	msg['Subject'] = Header(subject, 'utf-8')
	
	# force utf-8 since MIMEText() somehow generates a base64 encoded payload 
	# instead of utf-8 or quoted-printable
	msg.set_payload(text)
	msg.replace_header('Content-Transfer-Encoding', '8bit')
	
	server.sendmail(fromaddr, toaddr, msg.as_string())
	print "[OK]"

main()
