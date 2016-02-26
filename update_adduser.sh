#!/bin/bash

echoThenRun () { # echo and then run the command
  mkdir -p logs
  output_file="logs/output.log"
  toutput_file="logs/temp_output.log"
  status_file="logs/status.log"
  # $cmd 1>>$stdout_file 2>>$tderr_file 
  # ($cmd 2>&1 1>&3 | tee $status_file 3>&1 1>&2 | tee $stdout_file) > /logs/all.log 2>&1
  cmd=$1
  cmd_len=${#cmd}
  echo "COMMAND: $cmd" | tee -a $output_file | tee -a $status_file
  printf '%*s\n' $((cmd_len+10)) | tr ' ' - | tee -a $output_file >> $status_file
  $cmd &> $toutput_file
  # $cmd 2>>$status_file &>>$output_file
  if [ $? == 0 ]
  then
   # echo "COMMAND: $cmd" | tee -a $output_file | tee -a $status_file
   # printf '%*s\n' $((cmd_len+10)) | tr ' ' - | tee -a $output_file 
   cat $toutput_file >> $output_file
   echo "Success." | tee -a $output_file | tee -a $status_file
   # printf '%10s\n' | tr ' ' - | tee -a $output_file
  else
   # echo "COMMAND: $cmd" | tee -a $status_file
   printf '%*s\n' $((cmd_len+10)) | tr ' ' \* | tee -a $status_file | tee -a $output_file
   # printf '%*s\n' $((cmd_len+10)) | tr ' ' \#
   cat $toutput_file | tee -a $status_file | tee -a $output_file
   echo "ERROR." | tee -a $output_file | tee -a $status_file
   printf '%10s\n' | tr ' ' \* | tee -a $status_file | tee -a $output_file
   # printf '%22s\n' | tr ' ' \#
   # cat $output_file | tee -a $status_file
  fi
  printf '%10s\n' | tr ' ' - | tee -a $output_file >> $status_file
  rm $toutput_file
  return $ret
}

echoThenRun 'apt-get update'
echoThenRun 'apt-get -y upgrade'
echoThenRun 'adduser stack'
echoThenRun 'apt-get install sudo -y' # || yum install -y sudo'
echoThenRun 'sudo echo "stack ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers'
echoThenRun 'sudo apt-get install git -y' # || yum install -y git'
