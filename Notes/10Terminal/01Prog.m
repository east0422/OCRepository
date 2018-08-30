#import <Foundation/Foundation.h>
int main (int argc, const char* argv[]) {
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  NSLog(@"01Prog run!");
  [pool drain];
  return 0;
}