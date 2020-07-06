@isTest
public class Factsheet_Controller_Test {
    static testMethod void unitTest1() {
        Market__c mAU = new Market__c(Name='Australia',Vistex_Clearing_Account__c='0123456789');       
        insert mAU;
        
        Account acc = new Account();
        acc.Name = 'test Account';
        acc.Market__c = mAU.Id;
        acc.Is_Active__c = true;
        insert acc;
        
        CallCard__c cc = new CallCard__c();
        cc.Account__c = acc.Id;
        cc.Call_Card_Date__c = Date.today();
        insert cc;        		        
        
    	Factsheet__c factsheet = new Factsheet__c();
        factsheet.Object__c = 'Account';
        factsheet.Fieldset_Name__c = 'Germany_EUR_Outlets_FS';
        factsheet.Is_Active__c = true;
        factsheet.Market__c = mAU.Id;
        factsheet.RecordType__c = 'EUR - Outlets';
        factsheet.Show_Attachment_Section__c = true;
        factsheet.Show_Detail_View__c = true;
        insert factsheet;
        
        factsheet = [SELECT Id, Name, Object__c, Channel__c, Fieldset_Name__c, Is_Active__c, Market__c, RecordType__c FROM Factsheet__c WHERE Id =:factsheet.Id LIMIT 1];
        
        Factsheet_Item__c item = new Factsheet_Item__c();
        item.Factsheet__c = factsheet.Id;
        item.Is_Active__c = true;
        item.Fieldset_Name__c = 'Germany_EUR_Outlets_FS';
        item.Object__c = 'Account';
        item.Position__c = 0;
        
        Factsheet_Item__c item2 = new Factsheet_Item__c();
        item2.Object__c = 'CallCard__c';
        item2.Parent_Field_Name__c = 'Account__c';
        item2.Factsheet__c = factsheet.Id;
        item2.Is_Active__c = true;
        item2.Is_Related_to_Parent__c = true;
        item2.Fieldset_Name__c = 'Australia_FS';
        
        Factsheet_Item__c[] items = new Factsheet_Item__c[]{item, item2};
        insert items;
        
        Attachment at1 = new Attachment();
        at1.Name = 'Attachment1';
        at1.Body = Blob.valueOf('12345');
        at1.ParentId = factsheet.Id;
        at1.Description = 'test attachment';
        insert at1;
        
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test CV';
        cv.FirstPublishLocationId = factsheet.Id;
        cv.VersionData = at1.Body;
        cv.PathOnClient = 'testimage.png';
        insert cv;
        
        cv = [SELECT Id, Title, FirstPublishLocationId, PathOnClient, FileType, FileExtension, VersionData FROM ContentVersion WHERE ID =:cv.Id LIMIT 1];
        /*
        FeedItem fi1 = new FeedItem();
        fi1.RelatedRecordId = cv.Id;
        fi1.ParentId = acc.Id;
        fi1.Body = 'test feeditem';
        fi1.Title = 'Test Feeditem';
        fi1.Type = 'TextPost';
        insert fi1;
         */
        
        FactsheetImage fi = new FactsheetImage();
        System.assertNotEquals(null, fi, 'FactsheetImage is not null');
        
        fi = new FactsheetImage('testimage');
        System.assertNotEquals(null, fi, 'FactsheetImage is not null');
        
        System.debug('[test] cv.filetype: ' + cv.FileType + ', fileextension: ' + cv.FileExtension);
        fi = new FactsheetImage(cv);
        System.assertNotEquals(null, fi, 'FactsheetImage is not null');        
		        
        Test.startTest();
        System.debug('[test] factsheet.name: ' + factsheet.Name);
        String lbl = Factsheet_Controller.getCustomLabel('NoFactsheetFoundMessage');
        System.assertNotEquals(null, lbl);
        
        String objectLabel = Factsheet_Controller.getLabelForObject('Account', false);
        String objectLabelPlural = Factsheet_Controller.getLabelForObject('Account', true);
        System.assertEquals('Account', objectLabel, 'Object label for Account is correct');
        System.assertEquals('Accounts', objectLabelPlural, 'Object label plural for Account is correct');
        
        Factsheet__c f = Factsheet_Controller.getFactsheet(factsheet.Name);
        System.assertNotEquals(null, f, 'Factsheet ' + factsheet.Name + ' was found');
        
		List<FactsheetImage> images = Factsheet_Controller.getAttachmentsForRecord(factsheet.Id);
        System.debug('# of attachments for factsheet: ' + images.size());

        List<String> fieldNames = new List<String>{'Name', 'Call_Card_Date__c'};        
        List<List<bfColumn>> relatedData = Factsheet_Controller.getRelatedData('CallCard__c', 'Account__c', acc.Id, fieldNames, '');
        
        List<bfColumn> fieldSet = Factsheet_Controller.getFieldsetDetails('Account', 'Germany_EUR_Outlets_FS');
        System.assertNotEquals(null, fieldSet, 'controller returned the fieldset');
        
        SObject details = Factsheet_Controller.getRecordDetails('Account', acc.Id, new String[]{'Name','AccountNumber','Channel__c'});
        System.assertNotEquals(null, details, 'Account details returned successfully');
        
        Factsheet__c fsFromRecord = Factsheet_Controller.getFactsheetFromRecord(acc.Id, 'Account', 'EUR - Outlets', mAU.Id, '');
        System.assertNotEquals(null, fsFromRecord, 'Factsheet for account returned');
        
        Test.stopTest();
    }
}