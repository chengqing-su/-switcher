#include "switcher.h"

VALUE rb_mSwitcher;

void
Init_switcher(void)
{
  rb_mSwitcher = rb_define_module("Switcher");
}
