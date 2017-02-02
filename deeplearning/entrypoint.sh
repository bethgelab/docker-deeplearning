#!/bin/bash

# start ssh
service ssh restart

# Create user account
if [ -n "$USER" ]; then
   if [ -z "$USER_HOME" ]; then
      export USER_HOME=/home/$USER
   fi

   if [ -z "$USER_ID" ]; then
      export USER_ID=99
   fi


   if [ -n "$USER_ENCRYPTED_PASSWORD" ]; then
      useradd -M -d $USER_HOME -p $USER_ENCRYPTED_PASSWORD -u $USER_ID $USER > /dev/null
   else
      useradd -M -d $USER_HOME -u $USER_ID $USER > /dev/null
   fi
   
   # expects a comma-separated string of the form GROUP1:GROUP1ID,GROUP2,GROUP3:GROUP3ID,... 
   # (the GROUPID is optional, but needs to be separated from the group name by a ':')
   for i in $(echo $USER_GROUPS | sed "s/,/ /g")
   do
      if [[ $i == *":"* ]]
      then
	 addgroup ${i%:*} # > /dev/null
         groupmod -g ${i#*:} ${i%:*} #> /dev/null
         adduser $USER ${i%:*} #> /dev/null
      else
         addgroup $i > /dev/null
         adduser $USER $i > /dev/null
      fi
   done

   # set correct primary group
   if [ -n "$USER_GROUPS" ]; then
      group="$( cut -d ',' -f 1 <<< "$USER_GROUPS" )"
      if [[ $group == *":"* ]]
      then
         usermod -g ${group%:*} $USER & 
      else
         usermod -g $group $USER &
      fi
   fi

  if [ -n $CWD ]; then cd $CWD; fi
  echo "Running as user $USER"
  exec gosu $USER "$@"
else
  if [ -n $CWD ]; then cd $CWD; fi
  echo "Running as default container user"
  exec "$@"
fi
