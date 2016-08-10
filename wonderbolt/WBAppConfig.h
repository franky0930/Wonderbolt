//
//  SVAppConfig.h
//  Activate
//
//  
//  Copyright (c) 2013 Josh Koerpel. All rights reserved.
//

#ifndef wonderbolt_WBAppConfig_h
#define wonderbolt_WBAppConfig_h

//-----------------------------------------------------------------------
// APP
//-----------------------------------------------------------------------

#define WB_APP_NAME @"wonderbolt"
#define WB_APP_ITUNES_ID 873989562

//-----------------------------------------------------------------------
// DB
//-----------------------------------------------------------------------

#define WB_DATABASE_VERSION 2

#define WB_DATABASE @"wonderbolt"
#define WB_DATABASE_TYPE @"momd"
#define WB_DATABASE_NAME @"Wonderbolt.sqlite"

#define WB_DEVICES_PPI @"devicesPPI"
#define WB_DEVICES_PPI_TYPE @"plist"

//-----------------------------------------------------------------------
// EXTERNAL SERVICES/LIBRARIES
//-----------------------------------------------------------------------

#define WB_TESTFLIGHT_ENABLED
#define WB_TESTFLIGHT_ID @"cf40803b-c695-444a-a254-2c4ac70b9367"

#define WB_CRASHLYTICS_ENABLED
#define WB_CRASHLYTICS_API_KEY @"3f6403ef841a9f75659aa4a30ef0890c21289852"

//-----------------------------------------------------------------------
// BLANK MEASUREMENT VIEW
//-----------------------------------------------------------------------

#define WB_UNKNOWN_DEVICE_ALERT_TITLE @"Aww nuts!"
#define WB_UNKNOWN_DEVICE_ALERT_TEXT @"It looks like you're using a new device that's not compatiable yet. We'll be updating Wonderbolt soon!"
#define WB_UNKNOWN_DEVICE_ERROR_LABEL @"You're using a new device. We'll be updating wonder?bolt soon!"

//-----------------------------------------------------------------------
// CONFIG KEYS
//-----------------------------------------------------------------------

#define WB_K_DATABASE_VERSION @"DBVersion"

#endif
