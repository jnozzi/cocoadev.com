Hi,
I have written a small application, which will use General/IKPictureTaker component for the image selection.

Here the  problem is, if I select an image of 1*1 pixels height and width, after clicking on "Set" button, the application is crashing.

Could you help me out, if I am doing anything wrong. Here is the code snippet for the same.


		/* retrieve the imagePicker shared instance */
		General/IKPictureTaker *picker = General/[IKPictureTaker pictureTaker];
		
		[picker setTitle:@"Select Avatar"];
		//Limiting the Cropping area for the Picker
		General/NSSize size;
		size.height = 90.0f;
		size.width = 90.0f;
		[picker setValue:General/[NSValue valueWithSize:size] forKey:General/IKPictureTakerCropAreaSizeKey];
 
		if([mCAImageView image])
		{
			[picker setInputImage:self.originalCustomImage];
		}
		/* configure the image picker to show effects */
		[picker setValue:General/[NSNumber numberWithBool:YES] forKey:General/IKImagePickerShowEffectsKey];
		
		/* launch the imagePicker as a panel */
		
		[picker beginPictureTakerSheetForWindow:General/[NSApp keyWindow] withDelegate:self didEndSelector:@selector(imagePickerValidated:code:contextInfo:) contextInfo:nil];