#!/bin/sh
# Train SpamAssassin to like stuff in the Junk mailbox and dislike stuff in Spam.

TRASH=/home/ian/mail/Trash
SPAMBOX=/home/ian/mail/Junk

[ -w $TRASH ] || exit 1
[ -w $SPAMBOX ] || exit 1

# process Trash as ham
if sa-learn --ham $TRASH
then
  # delete Trash
  # /bin/cat /dev/null > $TRASH
  echo "ham processed"
else
  echo "ham not processed";
fi

# process Spam, don't delete-- I'll review it by hand later
sa-learn --spam $SPAMBOX
