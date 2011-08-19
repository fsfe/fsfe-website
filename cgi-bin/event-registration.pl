#!/usr/bin/perl

use CGI;
use POSIX qw(strftime);

# A form calling this CGI must have the following field:
# - eventid: a hidden field with the unique ID for the event. This is used for mapping below.
# - fullname: The full name of the registrant
# - email: The e-mail address of the registrant
# - comment: A textarea for comments from the registrant
# - The following paragraph for spam protection:
#    <p class="n">
#    Please do not put anything in here:
#    <input type="text" size="40" name="link"/>
#    </p>                           


# -----------------------------------------------------------------------------
# List of events
# -----------------------------------------------------------------------------

my %events = (
  "sfd2011vienna" => "SFD 2011 Vienna",
);

# -----------------------------------------------------------------------------
# List of recipients for registration e-mails for events
# -----------------------------------------------------------------------------

my %recipient = (
  "sfd2011vienna" => "sfd11vienna\@gollo.at",
);

# -----------------------------------------------------------------------------
# Get parameters
# -----------------------------------------------------------------------------

my $query = new CGI;

# Spam bots will be tempted to fill in this actually invisible field
if ($query->param("link")) {
  die "Invalid order, possibly spam.";
}
my $eventid = $query->param("eventid");
my $fullname = $query->param("fullname");
my $email = $query->param("email");
my $comment = $query->param("comment");

my $date = strftime "%Y-%m-%d", localtime;
my $time = strftime "%s", localtime;
my $eventname = $events{$eventid};
my $reference = "$eventid.$date." . substr $time, -3;

my $to1 = $recipient{$eventid};

my $subject = "$eventname registration $reference";

# -----------------------------------------------------------------------------
# Generate mail to responsible person
# -----------------------------------------------------------------------------

my $boundary = "NextPart$reference";

open(MAIL, "|/usr/lib/sendmail -t -f web\@fsfeurope.org");
print MAIL "From: web\@fsfeurope.org\n";
print MAIL "To: $to1\@fsfeurope.org\n";
print MAIL "Cc: $email";
print MAIL "Subject: $subject\n";
print MAIL "Mime-Version: 1.0\n";
print MAIL "Content-Type: multipart/mixed; boundary=$boundary\n";
print MAIL "Content-Transfer-Encoding: 8bit\n\n\n";

print MAIL "--$boundary\n";
print MAIL "Content-Type: text/plain; charset=utf-8\n";
print MAIL "Content-Transfer-Encoding: 8bit\n\n";

print MAIL "This registration for the event \"$eventname\" was sent via web interface\n\n";

print MAIL "--$boundary\n";
print MAIL "Content-Type: text/plain; charset=utf-8\n";
print MAIL "Content-Disposition: attachment; filename=$reference.txt\n";
print MAIL "Content-Description: Event registration\n";
print MAIL "Content-Transfer-Encoding: 8bit\n\n";

print MAIL "Registrant name: $fullname\n\n";
print MAIL "E-mail address: $email\n\n";
print MAIL "Comment: $comment\n\n";

print MAIL "--$boundary--\n";
                      
close MAIL;


# -----------------------------------------------------------------------------
# Inform user that everything was ok
# -----------------------------------------------------------------------------

print "Content-type: text/html\n\n";
print "<html>";
print "<head><title>Registration sent successfully</title></head>";
print "<body>";
print "<h1>Registration completed</h1>";
print "<p>";
print "Your registration $reference was sent. Thank you.<br /><br />";
print "Name: $fullname<br />\n\n";
print "E-mail: $email<br />\n\n";
print "Comment: $comment<br />\n\n";
print "</p>";
print "</body>";
print "</html>";
