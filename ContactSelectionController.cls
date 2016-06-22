public with sharing class ContactSelectionController {
    private final Account myAccount;
    private Account acc = new Account();
    private List<Contact> lContacts = new List<Contact>();
    public String contactSelected {get;set;}

    /**
      * @desc Constructor. Initialize required params from the Account.
      *     ·First save the Account received by the VF.
      *     ·Second query all fields that we will need to make some changes
      *     ·Third Asign a default value to the picklist. If we have previosly
      *         a Main_Contact__c show it, else render '--None--'
      * @param ApexPages.StandardController  Received by the VF.
    */
    public ContactSelectionController(ApexPages.StandardController stdController){
    	this.myAccount = (Account)stdController.getRecord();
    	acc = [SELECT Id, Name, Main_Contact__c, Main_Contact__r.FirstName, Main_Contact__r.LastName FROM Account WHERE id = :myAccount.Id];
    	this.contactSelected = (acc.Main_Contact__c != null) ? acc.Main_Contact__r.FirstName + ' ' + acc.Main_Contact__r.LastName : '--None--';
    }
    
    //  When VF render the <apex:selectOptions> get info from this List.
    //  The SelectOption ojbects contains a <key,value> like a Map<Key,Value>. In this case, we save data
    //      <ContactId,Contact Name> key for internal use, value will be rendered to the user.
    /**
      * @desc When VF render the <apex:selectOptions> get info from this returned list.
      *     SelectOption objects contains <key,value> like a Map. In this case, we store 
      *     <ContactId, Contact Name> (internalUse, Value Rendered to the user)
      * @return Return List<SelectOption> all Options for the <apex:selectOption>
    */
    public List<SelectOption> getContacts(){
    	List<SelectOption> options = new List<SelectOption>();
    	if(acc.Main_Contact__c != null) options.add(new SelectOption(acc.Main_Contact__c,acc.Main_Contact__r.FirstName + ' ' + acc.Main_Contact__r.LastName));
    	else options.add(new SelectOption('','--None--'));    	
    	lContacts = [SELECT Id, FirstName, LastName FROM Contact WHERE AccountId = :myAccount.Id];
    	
    	for(Contact c : lContacts){
    		if(acc.Main_Contact__c != c.Id) options.add(new SelectOption(c.Id,c.FirstName + ' ' + c.LastName));
    	}
    	return options;
    }
    
    // When click on 'Select!' button, save the selected option into our LookUp Field
    public void SaveChanges(){
    	acc.Main_Contact__c = contactSelected;
    	update acc;
    }
}
