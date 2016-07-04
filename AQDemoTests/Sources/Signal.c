//
//  Signal.c
//  AQDemo
//
//  Created by madding.lip on 7/4/16.
//  Copyright © 2016 Peng Li. All rights reserved.
//

#include <signal.h>

int main(int argc, char *argv[]) {
  struct sigaction mySigAction;
  mySigAction.sa_flags = SA_SIGINFO;

  sigemptyset(&mySigAction.sa_mask);
  sigaction(SIGQUIT, &mySigAction, NULL);
  sigaction(SIGILL, &mySigAction, NULL);
  sigaction(SIGTRAP, &mySigAction, NULL);
  sigaction(SIGABRT, &mySigAction, NULL);
  sigaction(SIGEMT, &mySigAction, NULL);
  sigaction(SIGFPE, &mySigAction, NULL);
  sigaction(SIGBUS, &mySigAction, NULL);
  sigaction(SIGSEGV, &mySigAction, NULL);
  sigaction(SIGSYS, &mySigAction, NULL);
  sigaction(SIGPIPE, &mySigAction, NULL);
  sigaction(SIGALRM, &mySigAction, NULL);
  sigaction(SIGXCPU, &mySigAction, NULL);
  sigaction(SIGXFSZ, &mySigAction, NULL);

  return 0;
}