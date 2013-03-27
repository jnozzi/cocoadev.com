Here's a piece of code to help changing the main display with Quartz Display Services for a 2 displays configuration

    
#include <General/ApplicationServices/General/ApplicationServices.h>

#define MAX_DISPLAYS 32

int main (int argc, const char ** argv) {

  General/CGDirectDisplayID activeDisplays[MAX_DISPLAYS];
  General/CGDisplayErr err;
  General/CGDisplayCount displayCount;
  General/CGDisplayConfigRef config;

  err = General/CGGetActiveDisplayList(MAX_DISPLAYS, activeDisplays, &displayCount);
  if ( err != kCGErrorSuccess )
  {
    printf("Cannot get displays (%d)\n", err);
    exit(1);
  }
 
  General/CGBeginDisplayConfiguration(&config);
  General/CGConfigureDisplayOrigin(config,activeDisplays[1], 0, 0); //Set the second display as the new main display by positionning at 0,0
  General/CGConfigureDisplayOrigin(config,activeDisplays[0], General/CGDisplayPixelsWide(activeDisplays[1])+1, 0); //Arrangement of the old main display to the right of the new main display
  General/CGCompleteDisplayConfiguration(config,kCGConfigureForSession);

  return 0;
}
