@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Job Status'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}

define root view entity ZI_JobStatus2
  as select from ZP_Jobs
  association [0..*] to ZI_JobStatText as _JobStatText on ZP_Jobs.JobStatus = _JobStatText.JobStatus
{
  key JobName                                                            as ApplicationJobName,
  key JobNumber                                                          as ApplicationJob,
      JobGroup,
      InternalReport,
      StepNumber,
      ScheduleStartDate,
      ScheduleStartTime,
      TargetSystem,
      ScheduleDate,
      ScheduleTime,
      JobSchedulerUser                                                   as ScheduledByUser,
      LastChangeDate,
      LastChangeTime,
      LastChangeUser,
      ReleaseDate,
      ReleaseTime,
      ReleaseUser,
      ExecutionStartDate,
      ExecutionStartTime,
      ExecutionEndDate,
      ExecutionEndTime,
      PeriodicJobMinutes,
      PeriodicJobHours,
      PeriodicJobDays,
      PeriodicJobWeeks,
      PeriodicJobMonths,
      IsPeriodicJob,
      DeleteJobFlag,
      EmergencyMode,
      @ObjectModel.text.element: ['StatusText']
      JobStatus                                                          as Status,
      _JobStatText[1: Language = $session.system_language].JobStatusText as StatusText,
      case JobStatus
        when 'Y' then 5  // Pronto
        when 'P' then 5  // Planejado
        when 'S' then 5  // Liberado
        when 'R' then 1  // Ativo
        when 'F' then 3  // Concluído
        when 'A' then 2  // Cancelado
        else 0 end                                                       as StatusCriticality,
      IsNewJobID,
      BackgroundUser,
      AuthorizationCheck,
      SuccessorJobNumber,
      PredecessorJobNumber,
      JobLogName,
      LatestStartDate,
      LatestStartTime,
      WorkProcessNumber,
      WorkProcessID,
      EventID,
      BackgroundEventParameter,
      TargetSystemReactive,
      JobClass,
      JobPriority,
      EventCount,
      JobStatusCheck,
      CalendarID,
      PeriodicBehavior,
      ExecutionServer,
      MonthEndCorrection,
      CalendarCorrection,
      ReactiveServer,
      RecoverLogicalSystem,
      RecoverObjectType,
      RecoverObjectKey,
      RecoverDescription,
      TargetServerGroup,
      _JobStatText
}
