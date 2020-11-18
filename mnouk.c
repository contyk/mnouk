#include <stdio.h>
#include <time.h>
#include <unistd.h>
#include <X11/Xlib.h>

#define BS 64

/* FIXME: Add locale support. */
int main () {
    time_t timer;
    char buf[BS];
    struct tm *tmi;
    Display *dpy;
    if (!(dpy = XOpenDisplay(NULL))) {
        printf("mnouk: cannot open display.\n");
        return 1;
    }
    Window w = DefaultRootWindow(dpy);
    while (1) {
        timer = time(NULL);
        tmi = localtime(&timer);
        strftime(buf, BS, "%A, %B %e, %Y %H:%M", tmi);
        XStoreName(dpy, w, buf);
        XSync(dpy, False);
        sleep(1);
    }
    return 0;
}
