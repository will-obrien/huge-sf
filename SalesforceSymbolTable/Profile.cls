// Generated by Illuminated Cloud on Tue Feb 14 12:00:53 IST 2017. Do not edit.

global class Profile extends SObject 
{
    global String Description;
    global Datetime LastReferencedDate;
    global Datetime LastViewedDate;
    global CustomSetup Parent;
    global Boolean PermissionsAccessCMC;
    global Boolean PermissionsActivateContract;
    global Boolean PermissionsActivateOrder;
    global Boolean PermissionsAllowEmailIC;
    global Boolean PermissionsAllowUniversalSearch;
    global Boolean PermissionsAllowViewKnowledge;
    global Boolean PermissionsApiEnabled;
    global Boolean PermissionsAssignPermissionSets;
    global Boolean PermissionsAssignTopics;
    global Boolean PermissionsAuthorApex;
    global Boolean PermissionsBulkApiHardDelete;
    global Boolean PermissionsBulkMacrosAllowed;
    global Boolean PermissionsCampaignInfluence2;
    global Boolean PermissionsCanApproveFeedPost;
    global Boolean PermissionsCanInsertFeedSystemFields;
    global Boolean PermissionsCanUseNewDashboardBuilder;
    global Boolean PermissionsChatterComposeUiCodesnippet;
    global Boolean PermissionsChatterEditOwnPost;
    global Boolean PermissionsChatterEditOwnRecordPost;
    global Boolean PermissionsChatterFileLink;
    global Boolean PermissionsChatterForSharePoint;
    global Boolean PermissionsChatterInternalUser;
    global Boolean PermissionsChatterInviteExternalUsers;
    global Boolean PermissionsChatterOwnGroups;
    global Boolean PermissionsConfigCustomRecs;
    global Boolean PermissionsConnectOrgToEnvironmentHub;
    global Boolean PermissionsContentAdministrator;
    global Boolean PermissionsConvertLeads;
    global Boolean PermissionsCreateAuditFields;
    global Boolean PermissionsCreateCustomizeDashboards;
    global Boolean PermissionsCreateCustomizeFilters;
    global Boolean PermissionsCreateCustomizeReports;
    global Boolean PermissionsCreateDashboardFolders;
    global Boolean PermissionsCreateMultiforce;
    global Boolean PermissionsCreateReportFolders;
    global Boolean PermissionsCreateTopics;
    global Boolean PermissionsCreateWorkspaces;
    global Boolean PermissionsCustomizeApplication;
    global Boolean PermissionsCustomMobileAppsAccess;
    global Boolean PermissionsCustomSidebarOnAllPages;
    global Boolean PermissionsDelegatedTwoFactor;
    global Boolean PermissionsDeleteActivatedContract;
    global Boolean PermissionsDeleteTopics;
    global Boolean PermissionsDistributeFromPersWksp;
    global Boolean PermissionsEditActivatedOrders;
    global Boolean PermissionsEditBrandTemplates;
    global Boolean PermissionsEditCaseComments;
    global Boolean PermissionsEditEvent;
    global Boolean PermissionsEditHtmlTemplates;
    global Boolean PermissionsEditKnowledge;
    global Boolean PermissionsEditMyDashboards;
    global Boolean PermissionsEditMyReports;
    global Boolean PermissionsEditOppLineItemUnitPrice;
    global Boolean PermissionsEditPublicDocuments;
    global Boolean PermissionsEditPublicTemplates;
    global Boolean PermissionsEditReadonlyFields;
    global Boolean PermissionsEditTask;
    global Boolean PermissionsEditTopics;
    global Boolean PermissionsEmailAdministration;
    global Boolean PermissionsEmailMass;
    global Boolean PermissionsEmailSingle;
    global Boolean PermissionsEmailTemplateManagement;
    global Boolean PermissionsEnableNotifications;
    global Boolean PermissionsExportReport;
    global Boolean PermissionsFlowUFLRequired;
    global Boolean PermissionsForceTwoFactor;
    global Boolean PermissionsGovernNetworks;
    global Boolean PermissionsIdentityConnect;
    global Boolean PermissionsIdentityEnabled;
    global Boolean PermissionsImportCustomObjects;
    global Boolean PermissionsImportLeads;
    global Boolean PermissionsImportPersonal;
    global Boolean PermissionsInstallMultiforce;
    global Boolean PermissionsLightningExperienceUser;
    global Boolean PermissionsManageAnalyticSnapshots;
    global Boolean PermissionsManageAuthProviders;
    global Boolean PermissionsManageBusinessHourHolidays;
    global Boolean PermissionsManageCallCenters;
    global Boolean PermissionsManageCases;
    global Boolean PermissionsManageCategories;
    global Boolean PermissionsManageChatterMessages;
    global Boolean PermissionsManageContentPermissions;
    global Boolean PermissionsManageContentProperties;
    global Boolean PermissionsManageContentTypes;
    global Boolean PermissionsManageCustomPermissions;
    global Boolean PermissionsManageCustomReportTypes;
    global Boolean PermissionsManageDashbdsInPubFolders;
    global Boolean PermissionsManageDataCategories;
    global Boolean PermissionsManageDataIntegrations;
    global Boolean PermissionsManageDynamicDashboards;
    global Boolean PermissionsManageEmailClientConfig;
    global Boolean PermissionsManageEncryptionKeys;
    global Boolean PermissionsManageExchangeConfig;
    global Boolean PermissionsManageInteraction;
    global Boolean PermissionsManageInternalUsers;
    global Boolean PermissionsManageIpAddresses;
    global Boolean PermissionsManageKnowledge;
    global Boolean PermissionsManageKnowledgeImportExport;
    global Boolean PermissionsManageLeads;
    global Boolean PermissionsManageLoginAccessPolicies;
    global Boolean PermissionsManageMobile;
    global Boolean PermissionsManageNetworks;
    global Boolean PermissionsManagePartnerNetConn;
    global Boolean PermissionsManagePasswordPolicies;
    global Boolean PermissionsManageProfilesPermissionsets;
    global Boolean PermissionsManagePvtRptsAndDashbds;
    global Boolean PermissionsManageRemoteAccess;
    global Boolean PermissionsManageReportsInPubFolders;
    global Boolean PermissionsManageRoles;
    global Boolean PermissionsManageSearchPromotionRules;
    global Boolean PermissionsManageSessionPermissionSets;
    global Boolean PermissionsManageSharing;
    global Boolean PermissionsManageSolutions;
    global Boolean PermissionsManageSynonyms;
    global Boolean PermissionsManageTranslation;
    global Boolean PermissionsManageTwoFactor;
    global Boolean PermissionsManageUnlistedGroups;
    global Boolean PermissionsManageUsers;
    global Boolean PermissionsMassInlineEdit;
    global Boolean PermissionsMergeTopics;
    global Boolean PermissionsModerateChatter;
    global Boolean PermissionsModerateNetworkUsers;
    global Boolean PermissionsModifyAllData;
    global Boolean PermissionsModifySecureAgents;
    global Boolean PermissionsNewReportBuilder;
    global Boolean PermissionsPasswordNeverExpires;
    global Boolean PermissionsPublishMultiforce;
    global Boolean PermissionsResetPasswords;
    global Boolean PermissionsRunFlow;
    global Boolean PermissionsRunReports;
    global Boolean PermissionsSalesConsole;
    global Boolean PermissionsScheduleReports;
    global Boolean PermissionsSelectFilesFromSalesforce;
    global Boolean PermissionsSendAnnouncementEmails;
    global Boolean PermissionsSendSitRequests;
    global Boolean PermissionsShareInternalArticles;
    global Boolean PermissionsShowCompanyNameAsUserBadge;
    global Boolean PermissionsSolutionImport;
    global Boolean PermissionsSubmitMacrosAllowed;
    global Boolean PermissionsTransferAnyCase;
    global Boolean PermissionsTransferAnyEntity;
    global Boolean PermissionsTransferAnyLead;
    global Boolean PermissionsTwoFactorApi;
    global Boolean PermissionsUpdateWithInactiveOwner;
    global Boolean PermissionsUseTeamReassignWizards;
    global Boolean PermissionsViewAllData;
    global Boolean PermissionsViewAllUsers;
    global Boolean PermissionsViewContent;
    global Boolean PermissionsViewDataCategories;
    global Boolean PermissionsViewEncryptedData;
    global Boolean PermissionsViewEventLogFiles;
    global Boolean PermissionsViewHelpLink;
    global Boolean PermissionsViewMyTeamsDashboards;
    global Boolean PermissionsViewPublicDashboards;
    global Boolean PermissionsViewPublicReports;
    global Boolean PermissionsViewSetup;
    global Boolean PermissionsWorkCalibrationUser;
    global Boolean PermissionsWorkDotComUserPerm;
    global Name Profile;
    global SObjectType SObjectType;
    global Datetime SystemModstamp;
    global UserLicense UserLicense;
    global Id UserLicenseId;
    global List<User> Users;
    global String UserType;

    global Profile()
    {
    }
}