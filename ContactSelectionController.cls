public with sharing class ContactSelectionController {
    private final Account myAccount;
    private Account acc = new Account();
    private List<Contact> lContacts = new List<Contact>();
    public String contactSelected {get;set;}
    
    
    
    public ContactSelectionController(ApexPages.StandardController stdController){
    	this.myAccount = (Account)stdController.getRecord();
    	acc = [SELECT Id, Name, Main_Contact__c, Main_Contact__r.FirstName, Main_Contact__r.LastName FROM Account WHERE id = :myAccount.Id];
    	this.contactSelected = (acc.Main_Contact__c != null) ? acc.Main_Contact__r.FirstName + ' ' + acc.Main_Contact__r.LastName : '--None--';
    }
    
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
    
    public void SaveChanges(){
    	acc.Main_Contact__c = contactSelected;
    	update acc;
    }
}