@isTest
public class test_CellController {
	public static testmethod void test_forceSave(){
		string acctList = '[{"Name":"asidhfoojasf","sobjectType":"Account"}]';
		list<id> acctIdList = CellController.forceSave(acctList);
		system.assertEquals(1, acctIdList.size());
	}

	public static testmethod void test_forceSave_withoutSobjectType(){
		boolean errorFound = false;
		string acctList = '[{"Name":"asidhfoojasf"}]';
		try {
			list<id> acctIdList = CellController.forceSave(acctList);
		} catch (Exception e){
			system.assertEquals('Required Property "sobjectType" not found.', e.getMessage());
			errorFound = true;
		}
		system.assertEquals(true, errorFound);
	}

	public static testmethod void test_forceSave_invalidSobjectType(){
		boolean errorFound = false;
		string acctList = '[{"Name":"asidhfoojasf","sobjectType":"vnfjruti"}]';
		try {
			list<id> acctIdList = CellController.forceSave(acctList);
		} catch (Exception e){
			system.assertEquals('SObject "vnfjruti" not found.', e.getMessage());
			errorFound = true;
		}
		system.assertEquals(true, errorFound);
	}

	public static testmethod void test_forceUpdate(){
		list<Account> acctList = new list<Account>();
		acctList.add(new Account(
			Name = 'awenfjwfljlasdf'
		));
		acctList.add(new Account(
			Name = 'bdlkjjadfdalkad'
		));
		insert acctList;

		string acctListStr = '[{"Id":"' + acctList[0].id + '", "Name":"aidfnekjfd","sobjectType":"Account"},{"Id":"' + acctList[1].id + '", "Name":"baskljlas","sobjectType":"Account"}]';
		CellController.forceUpdate(acctListStr);

		list<id> acctIdList = new list<id>();
		for (account acct : acctList){
			acctIdList.add(acct.id);
		}

		acctList = [select Id, Name from Account where Id in :acctIdList order by Name];
		system.assertEquals('aidfnekjfd', acctList[0].Name);
		system.assertEquals('baskljlas', acctList[1].Name);
	}

	public static testmethod void test_forceGetFieldList(){
		string fieldListStr = CellController.forceGetFieldList('User');
		list<CellController.objField> fieldList = (list<CellController.objField>)JSON.deserialize(fieldListStr, list<CellController.objField>.class);
		
		boolean usernameFound = false;
		boolean isActiveFound = false;
		boolean localeSidKeyFound = false;
		system.assertNotEquals(0, fieldList.size());
		for (CellController.objField field : fieldList){
			if (field.name == 'Username'){
				usernameFound = true;
				system.assertEquals('STRING', field.type);
			}
			if (field.name == 'IsActive'){
				isActiveFound = true;
				system.assertEquals('BOOLEAN', field.type);
			}
			if (field.name == 'LocaleSidKey'){
				localeSidKeyFound = true;
				system.assertEquals('PICKLIST', field.type);
				system.assertNotEquals(0, field.picklistItems.size());
			}
		}
		system.assertEquals(true, usernameFound);
		system.assertEquals(true, isActiveFound);
		system.assertEquals(true, localeSidKeyFound);
	}

	public static testmethod void test_forceGetFieldList_withoutObjectName(){
		boolean errorFound = false;
		try {
			CellController.forceGetFieldList(null);
		} catch (Exception e){
			system.assertEquals('objectName is null.', e.getMessage());
			errorFound = true;
		}
		system.assertEquals(true, errorFound);
	}

	public static testmethod void test_forceGetFieldList_invalidObjectName(){
		boolean errorFound = false;
		try {
			CellController.forceGetFieldList('sljaslasdfas');
		} catch (Exception e){
			system.assertEquals('SObject "sljaslasdfas" not found.', e.getMessage());
			errorFound = true;
		}
		system.assertEquals(true, errorFound);
	}

	public static testmethod void test_forceLoadDataWithFields(){
		list<Account> acctList = new list<Account>();
		acctList.add(new Account(
			Name = 'awenfjwfljlasdf'
		));
		acctList.add(new Account(
			Name = 'bdlkjjadfdalkad'
		));
		insert acctList;

		string acctListStr = CellController.forceLoadData('Account', 'Name, Phone');
		acctList = (list<Account>)JSON.deserialize(acctListStr, list<Account>.class);
		system.assertEquals(2, acctList.size());
	}

	public static testmethod void test_forceLoadDataWithoutFields(){
		list<Account> acctList = new list<Account>();
		acctList.add(new Account(
			Name = 'awenfjwfljlasdf'
		));
		acctList.add(new Account(
			Name = 'bdlkjjadfdalkad'
		));
		insert acctList;

		string acctListStr = CellController.forceLoadData('Account', null);
		acctList = (list<Account>)JSON.deserialize(acctListStr, list<Account>.class);
		system.assertEquals(2, acctList.size());
	}

	public static testmethod void test_forceLoadData_withoutSobject(){
		list<Account> acctList = new list<Account>();
		acctList.add(new Account(
			Name = 'awenfjwfljlasdf'
		));
		acctList.add(new Account(
			Name = 'bdlkjjadfdalkad'
		));
		insert acctList;

		boolean errorFound = false;
		try {
			string acctListStr = CellController.forceLoadData(null, 'Name, Phone');
		} catch (Exception e){
			system.assertEquals('objectName is null.', e.getMessage());
			errorFound = true;
		}
		system.assertEquals(true, errorFound);
	}

	public static testmethod void test_forceLoadData_invalidObjectName(){
		list<Account> acctList = new list<Account>();
		acctList.add(new Account(
			Name = 'awenfjwfljlasdf'
		));
		acctList.add(new Account(
			Name = 'bdlkjjadfdalkad'
		));
		insert acctList;

		boolean errorFound = false;
		try {
			string acctListStr = CellController.forceLoadData('kjdjfnasdf', 'Name, Phone');
		} catch (Exception e){
			system.assertEquals('SObject "kjdjfnasdf" not found.', e.getMessage());
			errorFound = true;
		}
		system.assertEquals(true, errorFound);
	}

	public static testmethod void test_forceLoadData_invalidFieldName(){
		list<Account> acctList = new list<Account>();
		acctList.add(new Account(
			Name = 'awenfjwfljlasdf'
		));
		acctList.add(new Account(
			Name = 'bdlkjjadfdalkad'
		));
		insert acctList;

		boolean errorFound = false;
		try {
			string acctListStr = CellController.forceLoadData('Account', 'Name, jdjfmlasfd');
		} catch (Exception e){
			system.assertEquals('Field "jdjfmlasfd" not found in SObject "Account".', e.getMessage());
			errorFound = true;
		}
		system.assertEquals(true, errorFound);
	}

	public static testmethod void test_forceQuery(){
		list<Account> acctList = new list<Account>();
		acctList.add(new Account(
			Name = 'awenfjwfljlasdf'
		));
		acctList.add(new Account(
			Name = 'bdlkjjadfdalkad'
		));
		insert acctList;

		string acctListStr = CellController.forceQuery('select Name, Phone from Account order by Name');
		acctList = (list<Account>)JSON.deserialize(acctListStr, list<Account>.class);
		system.assertEquals(2, acctList.size());
	}

	public static testmethod void test_forceDelete(){
		list<Account> acctList = new list<Account>();
		acctList.add(new Account(
			Name = 'awenfjwfljlasdf'
		));
		acctList.add(new Account(
			Name = 'bdlkjjadfdalkad'
		));
		insert acctList;

		list<id> idList = new list<id>();
		for (account acct : acctList){
			idList.add(acct.id);
		}

		CellController.forceDelete('Account', JSON.serialize(idList));
		acctList = [select id from Account where id in :idList];
		system.assertEquals(0, acctList.size());
	}

	public static testmethod void test_forceDelete_withoutSobject(){
		list<Account> acctList = new list<Account>();
		acctList.add(new Account(
			Name = 'awenfjwfljlasdf'
		));
		acctList.add(new Account(
			Name = 'bdlkjjadfdalkad'
		));
		insert acctList;

		boolean errorFound = false;
		try {
			CellController.forceDelete(null, '');
		} catch (Exception e){
			system.assertEquals('objectName is null.', e.getMessage());
			errorFound = true;
		}
		system.assertEquals(true, errorFound);
	}

	public static testmethod void test_forceDelete_invalideSobjectName(){
		list<Account> acctList = new list<Account>();
		acctList.add(new Account(
			Name = 'awenfjwfljlasdf'
		));
		acctList.add(new Account(
			Name = 'bdlkjjadfdalkad'
		));
		insert acctList;

		boolean errorFound = false;
		try {
			CellController.forceDelete('lkjasdfalsdfdf', '');
		} catch (Exception e){
			system.assertEquals('SObject "lkjasdfalsdfdf" not found.', e.getMessage());
			errorFound = true;
		}
		system.assertEquals(true, errorFound);
	}

	public static testmethod void test_forceDelete_withoutRecordIds(){
		list<Account> acctList = new list<Account>();
		acctList.add(new Account(
			Name = 'awenfjwfljlasdf'
		));
		acctList.add(new Account(
			Name = 'bdlkjjadfdalkad'
		));
		insert acctList;

		boolean errorFound = false;
		try {
			CellController.forceDelete('Account', null);
		} catch (Exception e){
			system.assertEquals('recordIds is null.', e.getMessage());
			errorFound = true;
		}
		system.assertEquals(true, errorFound);
	}


}