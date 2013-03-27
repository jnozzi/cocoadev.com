Hi,

Why this code doesn't works fine ?! tmpDate != dateNew

    

  {
    General/NSDate  *tmpDate = General/[NSDate date];
    
    General/NSNumber *tmpNum = General/[NSNumber numberWithFloat:[tmpDate timeIntervalSince1970]];    
    General/NSDate *dateNew = General/[NSDate dateWithTimeIntervalSince1970:[tmpNum floatValue]];
    
    General/NSLog(@"%@", [tmpDate descriptionWithLocale:nil]);
    General/NSLog(@"%@", [dateNew descriptionWithLocale:nil]);
  }



    

[Switching to process 4649 local thread 0x2e03]
Running�
Current language:  auto; currently objective-c
2010-08-14 14:03:25.280 NSCalendar2[4649:813] 2010-08-14 14:03:24 +0200
2010-08-14 14:03:25.731 NSCalendar2[4649:813] 2010-08-14 14:03:12 +0200



----

You must use double instead of float

    
  {
    General/NSDate  *tmpDate = General/[NSDate date];
    
    General/NSNumber *tmpDouble = General/[NSNumber numberWithDouble:[tmpDate timeIntervalSince1970]];
    General/NSDate *dateNew = General/[NSDate dateWithTimeIntervalSince1970:[tmpDouble doubleValue]];
    
    General/NSLog(@"%@", [tmpDate descriptionWithLocale:nil]);
    General/NSLog(@"%@", [dateNew descriptionWithLocale:nil]);
  }


    
2010-08-14 16:03:28.998 NSCalendar2[4748:813] 2010-08-14 16:03:01 +0200
2010-08-14 16:03:29.448 NSCalendar2[4748:813] 2010-08-14 16:03:01 +0200


JM Marino
http://jm.marino.free.fr