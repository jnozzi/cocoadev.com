    
General/NSAlertPanel.beginAlertSheet(
	String title, 
	String defaultButton, 
	String alternateButton, 
	String otherButton, 
	General/NSWindow docWindow, 
	Object modalDelegate, 
	General/NSSelector willEndSelector, 
	General/NSSelector didEndSelector, 
	Object contextInfo, 
	String msg);

The two selectors must have the following signature:
    
public void willEndAlert(General/NSWindow sheet, int returnCode, Object contextInfo)
public void didEndAlert(General/NSWindow sheet, int returnCode, Object contextInfo)

Return codes are statics in General/NSAlertPanel
    
    public static final int General/DefaultReturn = 1;
    public static final int General/AlternateReturn = 0;
    public static final int General/OtherReturn = -1;
    public static final int General/ErrorReturn = -2;


Example:
    
public void willEndAlert(General/NSWindow sheet, int returnCode, Object contextInfo) {
	switch (returnCode) {
	case General/NSAlertPanel.General/DefaultReturn:
		System.out.println("modalDelegate.willEndAlert() Save");
		break;
	case General/NSAlertPanel.General/AlternateReturn:
		System.out.println("modalDelegate.willEndAlert() Don't Save");
		break;
	case General/NSAlertPanel.General/OtherReturn:
		System.out.println("modalDelegate.willEndAlert() Cancel");
		break;
	default:
		System.out.println("modalDelegate.willEndAlert() Error " + returnCode);
	}
}


General/FrancoisFrisch