/* settings-mon.c
 *
 * Copyright (C) 2017 Stefan Saraev
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
 * 02110-1301, USA
 */

#include <sys/inotify.h>
#include <sys/stat.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#ifndef WORK_DIR
#define WORK_DIR "/tmp/settings-mon"
#endif

#ifndef RESTART_SCRIPT
#define RESTART_SCRIPT "/tmp/settings-mon/restart.sh"
#endif

struct stat st = {0};

static void handleEvent(struct inotify_event *i)
{
  if (i->len > 0)
  {
    if (strcmp(i->name, "settings.xml") == 0)
    {
      if (i->mask & IN_CLOSE_WRITE)
      {
        if (access(RESTART_SCRIPT, X_OK) == 0)
          system(RESTART_SCRIPT);
        else
          printf("%s IN_CLOSE_WRITE\n", i->name);
      }
    }
  }
}

#define BUF_LEN (10 * (sizeof(struct inotify_event) + NAME_MAX + 1))

int main(int argc, char *argv[])
{
  int inotifyFd, wd;
  char buf[BUF_LEN] __attribute__ ((aligned(8)));
  ssize_t numRead;
  char *p;
  struct inotify_event *event;

  if (stat(WORK_DIR, &st) == -1)
  {
    mkdir(WORK_DIR, 0755);
  }

  inotifyFd = inotify_init();
  if (inotifyFd == -1)
  {
    printf("inotify_init\n");
    exit(EXIT_FAILURE);
  }

  wd = inotify_add_watch(inotifyFd, WORK_DIR, IN_ALL_EVENTS);
  if (wd == -1)
  {
    printf("inotify_add_watch\n");
    exit(EXIT_FAILURE);
  }

  printf("Watching %s using wd %d\n", WORK_DIR, wd);

  for (;;) {
    numRead = read(inotifyFd, buf, BUF_LEN);
    if (numRead == 0)
    {
      printf("read() from inotify fd returned 0!\n");
      exit(EXIT_FAILURE);
    }

    if (numRead == -1)
    {
      printf("read\n");
      exit(EXIT_FAILURE);
    }

    for (p = buf; p < buf + numRead; ) {
      event = (struct inotify_event *) p;
      handleEvent(event);

      p += sizeof(struct inotify_event) + event->len;
    }
  }

  exit(EXIT_SUCCESS);
}
