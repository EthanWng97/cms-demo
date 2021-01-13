CREATE  PROCEDURE [dbo].[ab_test_control_Action]
	@xml nvarchar(max) OUTPUT,
	@xmlEntity nvarchar(max) OUTPUT,
	@createUser nvarchar(36),
	@error nvarchar(500) output
AS

BEGIN

	declare @procName nvarchar(50),    --存储过程名称
        @language nvarchar(50), --国家代码
        @position bigint;
	--错误位置
	set @procName = 'ab_test_control_Action';
	set @language = @error;
	set @position = 1;



	declare  @TmpXML xml,
         @TmpXMLEntity xml;
	set @TmpXML = CONVERT(xml,@xml);
	set @TmpXMLEntity = CONVERT(xml,@xmlEntity);

	--定义@xml返回XML临时表
	DECLARE @OutInfo TABLE 
        (
		action nvarchar(20),
		sId varchar(36),
		info nvarchar(max),
		error nvarchar(max)
        );
	DECLARE @StrXML nvarchar(max);
	DECLARE @info_return varchar(MAX);


	--初始化扩展传出参数-------------------
	SET @xmlEntity='<dataset><table></table></dataset>';

	DECLARE @return_error nvarchar(255);
	BEGIN TRY
DECLARE
       @sId varchar(36),
       @textBox nvarchar(50),
       @checkBox bit,
       @dateBox datetime,
       @richTextBox nvarchar(256),
       @dropDownList int,
       @foreignKey varchar(36),
       @dropDownTree int,
       @numberBox decimal(18,2),
       @numberSpinner int,
       @timeSpinner nvarchar(10),
       @dateTimeBox datetime,
       @sTamp timestamp,
       @xmlinfo xml,
       @info nvarchar(MAX),
       @action nvarchar(20);


    DECLARE ab_test_c_cur CURSOR FOR
         SELECT
		C.value('sId[1]','varchar(36)') as sId,
		C.value('textBox[1]','nvarchar(50)') as textBox,
		C.value('checkBox[1]','bit') as checkBox,
		C.value('dateBox[1]','datetime') as dateBox,
		C.value('richTextBox[1]','nvarchar(256)') as richTextBox,
		C.value('dropDownList[1]','int') as dropDownList,
		C.value('foreignKey[1]','varchar(36)') as foreignKey,
		C.value('dropDownTree[1]','int') as dropDownTree,
		C.value('numberBox[1]','decimal(18,2)') as numberBox,
		C.value('numberSpinner[1]','int') as numberSpinner,
		C.value('timeSpinner[1]','nvarchar(10)') as timeSpinner,
		C.value('dateTimeBox[1]','datetime') as dateTimeBox,
		C.value('sTamp[1]','timestamp') as sTamp,
		T.C.query('info') as xmlinfo,
		C.value('action[1]','nvarchar(20)') as action
	from @TmpXML.nodes('/dataset/table/row') as T(C);


 	OPEN ab_test_c_cur;

		FETCH NEXT FROM ab_test_c_cur INTO
			 @sId,
			 @textBox,
			 @checkBox,
			 @dateBox,
			 @richTextBox,
			 @dropDownList,
			 @foreignKey,
			 @dropDownTree,
			 @numberBox,
			 @numberSpinner,
			 @timeSpinner,
			 @dateTimeBox,
			 @sTamp,
			 @xmlinfo,
			 @action;
		set @info = CONVERT(nvarchar(MAX),@xmlinfo);
		set @info = replace(@info,'<info>','<dataset>');
		set @info = replace(@info,'</info>','</dataset>');


	WHILE @@fetch_status = 0
	BEGIN
		set @info_return = '';
		set @return_error = @language;
		IF @action='add'
          BEGIN
			EXEC ab_test_control_Add
                   @sId OUTPUT,
                   @textBox,
                   @checkBox,
                   @dateBox,
                   @richTextBox,
                   @dropDownList,
                   @foreignKey,
                   @dropDownTree,
                   @numberBox,
                   @numberSpinner,
                   @timeSpinner,
                   @dateTimeBox,
                   @createUser,
                   @return_error OUTPUT;
		END;
	    ELSE IF @action='upp'
          BEGIN
			EXEC ab_test_control_Upp
                   @sId,
                   @textBox,
                   @checkBox,
                   @dateBox,
                   @richTextBox,
                   @dropDownList,
                   @foreignKey,
                   @dropDownTree,
                   @numberBox,
                   @numberSpinner,
                   @timeSpinner,
                   @dateTimeBox,
                   @createUser,
                   @sTamp,
                   @return_error OUTPUT;
		END;
	    ELSE IF @action='del'
          BEGIN
			EXEC ab_test_control_Del @sId,@createUser,@return_error output;
		END;
	    else
          set @return_error = 'Marked['+@action+'] undefined!';
		insert into @OutInfo
			(action,sId,info,error)
		values(@action, @sId, @info_return, @return_error);
		FETCH NEXT FROM ab_test_c_cur INTO
			 @sId,
			 @textBox,
			 @checkBox,
			 @dateBox,
			 @richTextBox,
			 @dropDownList,
			 @foreignKey,
			 @dropDownTree,
			 @numberBox,
			 @numberSpinner,
			 @timeSpinner,
			 @dateTimeBox,
			 @sTamp,
			 @xmlinfo,
			 @action;
		set @info = CONVERT(nvarchar(MAX),@xmlinfo);
		set @info = replace(@info,'<info>','<dataset>');
		set @info = replace(@info,'</info>','</dataset>');

	END;
	CLOSE ab_test_c_cur;
	DEALLOCATE ab_test_c_cur;
   
	--传出XML执行参数
	SET @StrXML = (SELECT *
	FROM @OutInfo row
	for XML AUTO,ELEMENTS,ROOT('table'));
	set @xml = '<dataset>'+@StrXML+'</dataset>';
   
	SET @error='0';
END TRY
BEGIN CATCH
      --set @error='error:'+ERROR_MESSAGE();
      set @error = @procName+':'+dbo.SpringSpTranslation_Error(@procName,@language,999,Convert(varchar(150),@position),ERROR_MESSAGE(),'','','');
END CATCH;

END;

CREATE PROCEDURE [dbo].[ab_test_control_Add]
	@sId varchar(36) OUTPUT,
	@textBox nvarchar(50),
	@checkBox bit,
	@dateBox datetime,
	@richTextBox nvarchar(256),
	@dropDownList int,
	@foreignKey varchar(36),
	@dropDownTree int,
	@numberBox decimal(18,2),
	@numberSpinner int,
	@timeSpinner nvarchar(10),
	@dateTimeBox datetime,
	@createUser varchar(36),
	@error nvarchar(500) OUTPUT
AS

BEGIN

	declare @procName nvarchar(50),    --存储过程名称
        @language nvarchar(50),    --语言代码
        @position bigint;
	--错误位置
	set @procName = 'ab_test_control_Add';
	set @language = @error;
	set @position = 1;

	begin transaction;

	BEGIN TRY
     set @sId=lower(newid()); 
     Insert Into ab_test_control
		(
		sId,
		textBox,
		checkBox,
		dateBox,
		richTextBox,
		dropDownList,
		foreignKey,
		dropDownTree,
		numberBox,
		numberSpinner,
		timeSpinner,
		dateTimeBox,
		createUser,
		createTime,
		modifyUser,
		modifyTime
		)
	Values(
			@sId,
			@textBox,
			@checkBox,
			@dateBox,
			@richTextBox,
			@dropDownList,
			@foreignKey,
			@dropDownTree,
			@numberBox,
			@numberSpinner,
			@timeSpinner,
			@dateTimeBox,
			@createUser,
			sysdatetimeoffset(),
			@createUser,
			sysdatetimeoffset()
           );
     commit transaction;
     set @error='0';
END TRY
 
BEGIN CATCH
      rollback transaction;
      --set @error='error:'+ERROR_MESSAGE();
      set @error = @procName+':'+dbo.SpringSpTranslation_Error(@procName,@language,999,Convert(varchar(150),@position),ERROR_MESSAGE(),'','','');
END CATCH;

END;

CREATE PROCEDURE [dbo].[ab_test_control_Del]
	@sId varchar(36),
	@modifyUser varchar(36),
	@error nvarchar(500) OUTPUT
AS

BEGIN

	declare @procName nvarchar(50),    --存储过程名称
        @language nvarchar(50),    --语言代码
        @position bigint;
	--错误位置
	set @procName = 'ab_test_control_Del';
	set @language = @error;
	set @position = 1;

	begin transaction;

	BEGIN TRY
     DELETE FROM ab_test_control WHERE sId=@sId;
     commit transaction;
     set @error='0';
END TRY

BEGIN CATCH
      rollback transaction;
      --set @error='error:'+ERROR_MESSAGE();
      set @error = @procName+':'+dbo.SpringSpTranslation_Error(@procName,@language,999,Convert(varchar(150),@position),ERROR_MESSAGE(),'','','');
END CATCH;

END;

CREATE PROCEDURE [dbo].[ab_test_control_Upp]
	@sId varchar(36),
	@textBox nvarchar(50),
	@checkBox bit,
	@dateBox datetime,
	@richTextBox nvarchar(256),
	@dropDownList int,
	@foreignKey varchar(36),
	@dropDownTree int,
	@numberBox decimal(18,2),
	@numberSpinner int,
	@timeSpinner nvarchar(10),
	@dateTimeBox datetime,
	@modifyUser varchar(36),
	@sTamp timestamp,
	@error varchar(500) OUTPUT
AS

BEGIN

	declare @procName nvarchar(50),    --存储过程名称
        @language nvarchar(50),    --语言代码
        @position bigint;
	--错误位置
	set @procName = 'ab_test_control_Upp';
	set @language = @error;
	set @position = 1;

	begin transaction;

	BEGIN TRY
     Update ab_test_control Set
             textBox=@textBox,
             checkBox=@checkBox,
             dateBox=@dateBox,
             richTextBox=@richTextBox,
             dropDownList=@dropDownList,
             foreignKey=@foreignKey,
             dropDownTree=@dropDownTree,
             numberBox=@numberBox,
             numberSpinner=@numberSpinner,
             timeSpinner=@timeSpinner,
             dateTimeBox=@dateTimeBox,
             modifyUser=@modifyUser,
             modifyTime=sysdatetimeoffset()
           WHERE sId=@sId;
     commit transaction;
     set @error='0';
END TRY

BEGIN CATCH
      rollback transaction;
      --set @error='error:'+ERROR_MESSAGE();
      set @error = @procName+':'+dbo.SpringSpTranslation_Error(@procName,@language,999,Convert(varchar(150),@position),ERROR_MESSAGE(),'','','');
END CATCH;

END;

CREATE TABLE [dbo].[springTb]
(
	[sId] [varchar](36) NOT NULL,
	[pId] [varchar](36) NULL,
	[tbType] [int] NULL,
	[name] [nvarchar](50) NULL,
	[shortName] [nvarchar](50) NULL,
	[description] [nvarchar](256) NULL,
	[descriptionEn] [nvarchar](256) NULL,
	[tbName] [nvarchar](50) NULL,
	[fieldName] [nvarchar](50) NULL,
	[fieldNo] [int] NULL,
	[isFile] [bit] NULL,
	[filePathNo] [varchar](36) NULL,
	[storedProcName] [nvarchar](256) NULL,
	[remark] [nvarchar](max) NULL,
	[queue] [int] NULL,
	[createUser] [varchar](36) NULL,
	[createTime] [datetimeoffset](7) NULL,
	[modifyUser] [varchar](36) NULL,
	[modifyTime] [datetimeoffset](7) NULL,
	[sTamp] [timestamp] NULL,
	CONSTRAINT [PK_Sys_Table] PRIMARY KEY CLUSTERED 
(
	[sId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[springTb] ADD  CONSTRAINT [DF_Sys_Table_createTime]  DEFAULT (getdate()) FOR [createTime]
GO

ALTER TABLE [dbo].[springTb] ADD  CONSTRAINT [DF_Sys_Table_modifyTime]  DEFAULT (getdate()) FOR [modifyTime]
GO

CREATE TABLE [dbo].[springField]
(
	[sId] [varchar](36) NOT NULL,
	[tbId] [varchar](36) NULL,
	[isField] [bit] NULL,
	[name] [nvarchar](50) NULL,
	[description] [nvarchar](256) NULL,
	[descriptionEn] [nvarchar](256) NULL,
	[fdType] [nvarchar](50) NULL,
	[length] [bigint] NULL,
	[decimal] [bigint] NULL,
	[isNullable] [bit] NULL,
	[isUseable] [bit] NULL,
	[isForeignKey] [bit] NULL,
	[fkTbId] [varchar](36) NULL,
	[fkFieldId] [varchar](36) NULL,
	[defaultValue] [nvarchar](500) NULL,
	[uiType] [int] NULL,
	[uiMask] [nvarchar](100) NULL,
	[uiVisible] [bit] NULL,
	[uiReadOnly] [bit] NULL,
	[uiWidth] [int] NULL,
	[uiDefault] [nvarchar](200) NULL,
	[isAddField] [bit] NULL,
	[isEditField] [bit] NULL,
	[orderType] [int] NULL,
	[remark] [nvarchar](max) NULL,
	[queue] [int] NULL,
	[createUser] [varchar](36) NULL,
	[createTime] [datetimeoffset](7) NULL,
	[modifyUser] [varchar](36) NULL,
	[modifyTime] [datetimeoffset](7) NULL,
	[sTamp] [timestamp] NULL
)

USE [OceanCms]
GO
/****** Object:  StoredProcedure [dbo].[springTb_Action]    Script Date: 31/12/2020 上午 11:32:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  PROCEDURE [dbo].[springTb_Action]
	@xml nvarchar(max) OUTPUT,
	@xmlEntity nvarchar(max) OUTPUT,
	@createUser nvarchar(36),
	@error nvarchar(500) output
AS

BEGIN

	declare @procName nvarchar(50),    --存储过程名称
        @language nvarchar(50), --国家代码
        @position bigint;
	--错误位置
	set @procName = 'springTb_Action';
	set @language = @error;
	set @position = 1;



	declare  @TmpXML xml,
         @TmpXMLEntity xml;
	set @TmpXML = CONVERT(xml,@xml);
	set @TmpXMLEntity = CONVERT(xml,@xmlEntity);

	--定义@xml返回XML临时表
	DECLARE @OutInfo TABLE 
        (
		action nvarchar(20),
		sId varchar(36),
		info nvarchar(max),
		error nvarchar(max)
        );
	DECLARE @StrXML nvarchar(max);
	DECLARE @info_return varchar(MAX);


	--初始化扩展传出参数-------------------
	SET @xmlEntity='<dataset><table></table></dataset>';

	DECLARE @return_error nvarchar(255);
	BEGIN TRY
DECLARE
       @sId varchar(36),
       @pId varchar(36),
       @tbType int,
       @name nvarchar(50),
       @shortName nvarchar(50),
       @description nvarchar(256),
       @descriptionEn nvarchar(256),
       @tbName nvarchar(50),
       @fieldName nvarchar(50),
       @fieldNo int,
       @isFile bit,
       @filePathNo varchar(36),
       @storedProcName nvarchar(256),
       @remark nvarchar(max),
       @sTamp timestamp,
       @queue int,
       @xmlinfo xml,
       @info nvarchar(MAX),
       @action nvarchar(20);


    DECLARE springTb_cur CURSOR FOR
         SELECT
		C.value('sId[1]','varchar(36)') as sId,
		C.value('pId[1]','varchar(36)') as pId,
		C.value('tbType[1]','int') as tbType,
		C.value('name[1]','nvarchar(50)') as name,
		C.value('shortName[1]','nvarchar(50)') as shortName,
		C.value('description[1]','nvarchar(256)') as description,
		C.value('descriptionEn[1]','nvarchar(256)') as descriptionEn,
		C.value('tbName[1]','nvarchar(50)') as tbName,
		C.value('fieldName[1]','nvarchar(50)') as fieldName,
		C.value('fieldNo[1]','int') as fieldNo,
		C.value('isFile[1]','bit') as isFile,
		C.value('filePathNo[1]','varchar(36)') as filePathNo,
		C.value('storedProcName[1]','nvarchar(256)') as storedProcName,
		C.value('remark[1]','nvarchar(max)') as remark,
		C.value('sTamp[1]','timestamp') as sTamp,
		C.value('queue[1]','int') as queue,
		T.C.query('info') as xmlinfo,
		C.value('action[1]','nvarchar(20)') as action
	from @TmpXML.nodes('/dataset/table/row') as T(C);


 	OPEN springTb_cur;

		FETCH NEXT FROM springTb_cur INTO
			 @sId,
			 @pId,
			 @tbType,
			 @name,
			 @shortName,
			 @description,
			 @descriptionEn,
			 @tbName,
			 @fieldName,
			 @fieldNo,
			 @isFile,
			 @filePathNo,
			 @storedProcName,
			 @remark,
			 @sTamp,
			 @queue,
			 @xmlinfo,
			 @action;
		set @info = CONVERT(nvarchar(MAX),@xmlinfo);
		set @info = replace(@info,'<info>','<dataset>');
		set @info = replace(@info,'</info>','</dataset>');


	WHILE @@fetch_status = 0
	BEGIN
		set @info_return = '';
		set @return_error = @language;

		select @action, @info;

		IF @action='Add'
          BEGIN
			EXEC springTb_Add
                   @sId OUTPUT,
                   @pId,
                   @tbType,
                   @name,
                   @shortName,
                   @description,
                   @descriptionEn,
                   @tbName,
                   @fieldName,
                   @fieldNo,
                   @isFile,
                   @filePathNo,
                   @storedProcName,
                   @remark,
                   @createUser,
                   @return_error OUTPUT;
		END;
	    ELSE IF @action='Upp'
          BEGIN
			EXEC springTb_Upp
                   @sId,
                   @tbType,
                   @name,
                   @shortName,
                   @description,
                   @descriptionEn,
                   @tbName,
                   @fieldName,
                   @fieldNo,
                   @isFile,
                   @filePathNo,
                   @storedProcName,
                   @remark,
                   @createUser,
                   @sTamp,
                   @return_error OUTPUT;
		END;
	    ELSE IF @action='Del'
          BEGIN
			EXEC springTb_Del @sId,@createUser,@return_error output;
		END;
	    ELSE IF @action='Move'
          BEGIN
			EXEC dbo.springTb_Move @pId,@info,@createUser,@return_error output;
		END;
        ELSE IF @action='paste'
          BEGIN
			EXEC dbo.springTb_Paste @sId,@pId,@createUser,@return_error output;
		END;
        ELSE IF @action='getmoudel'
          BEGIN
			EXEC dbo.springTb_GetMoudel @sId,@info_return output,@return_error output;
			if(@return_error='0')
				set @info_return='@' + @info_return;
		END;
        ELSE IF @action='setmoudel'
          BEGIN
			set @xmlinfo = CONVERT(nvarchar(MAX),'<root>' + @info + '</root>');

			SELECT @info = C.value('dataset[1]','varchar(max)')
			from @xmlinfo.nodes('/root') as T(C);
			--set @info_return='@' + @info;
			--set @return_error ='0';
			EXEC dbo.springTb_SetMoudel @sId,@info,@createUser,@return_error output;
		END;
	    else
          set @return_error = 'Marked['+@action+'] undefined!';
		insert into @OutInfo
			(action,sId,info,error)
		values(@action, @sId, @info_return, @return_error);
		FETCH NEXT FROM springTb_cur INTO
			 @sId,
			 @pId,
			 @tbType,
			 @name,
			 @shortName,
			 @description,
			 @descriptionEn,
			 @tbName,
			 @fieldName,
			 @fieldNo,
			 @isFile,
			 @filePathNo,
			 @storedProcName,
			 @remark,
			 @sTamp,
			 @queue,
			 @xmlinfo,
			 @action;
		set @info = CONVERT(nvarchar(MAX),@xmlinfo);
		set @info = replace(@info,'<info>','<dataset>');
		set @info = replace(@info,'</info>','</dataset>');

	END;
	CLOSE springTb_cur;
	DEALLOCATE springTb_cur;
   
	--传出XML执行参数
	SET @StrXML = (SELECT *
	FROM @OutInfo row
	for XML AUTO,ELEMENTS,ROOT('table'));
	set @xml = '<dataset>'+@StrXML+'</dataset>';
   
	SET @error='0';
END TRY
BEGIN CATCH
      --set @error='error:'+ERROR_MESSAGE();
      set @error = @procName+':'+dbo.SpringSpTranslation_Error(@procName,@language,999,Convert(varchar(150),@position),ERROR_MESSAGE(),'','','');
END CATCH;

END;

USE [OceanCms]
GO
/****** Object:  StoredProcedure [dbo].[springTb_Del]    Script Date: 4/1/2021 下午 2:07:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


ALTER PROCEDURE [dbo].[springTb_Del]
	@sId varchar(36),
	@modifyUser nvarchar(50),
	@error varchar(255) OUTPUT
AS

BEGIN

	declare @procName nvarchar(50),    --存储过程名称
        @language nvarchar(50),    --语言代码
        @position bigint;
	--错误位置
	set @procName = 'springTb_Del';
	set @language = @error;
	set @position = 1;

	declare  @count int,
         @pId varchar(36),
		 @tabname nvarchar(128),
         @queue int;

	--EXEC dbo.SpringCheckFK 'springTb',@sId,@error OUTPUT;
	--if @error!='0'
	--	return;

	select @count=count(*)
	from springTb
	where pId=@sId;
	if @count>0
   begin
		set @error='请先删除子项表。';
		return;
	end;

	select @tabname=name, @pId=pId, @queue=queue
	from springTb
	where sId = @sId;

	begin transaction;

	BEGIN TRY
     delete from springTranslation where tbName='springTb' and (sId=@sId or path=('pId='+@sId));
     delete from springTranslation where tbName='springField' and path=('tbId='+@sId); 
     delete from springSp where tbId=@sId;
     delete from dbo.springTbSpSetup where sId=@sId;
     delete from dbo.springFdList_d where mId in (select sId
	from dbo.springFdList_m
	where tbId=@sId);
     delete from dbo.springFdList_m where tbId=@sId;
     delete from dbo.springFdForeignKey where tbId=@sId;
     delete from dbo.springTbUiTemplate where tbId=@sId;
     
     delete from dbo.springFileList where sId in (SELECT fileId
	FROM [dbo].[springFileTableRel]
	where tbName like @tabname)
     delete  FROM  [dbo].[springFileTableRel] where tbName like @tabname

     delete from springTb where sId=@sId;
     if @pId is null
		update springTb set queue=queue-1 where pId is null and queue>@queue;
     else
		 update springTb set queue=queue-1 where pId=@pId and queue>@queue;

     commit transaction;
     set @error='0';
END TRY

BEGIN CATCH
      rollback transaction;
      --set @error = dbo.SpringSpTranslation_Error(@procName,@language,999,Convert(varchar(150),@position),ERROR_MESSAGE(),'','','');
      set @error='error:'+ERROR_MESSAGE();
END CATCH;

END;


USE [SpringCms]
GO
/****** Object:  StoredProcedure [dbo].[oceanLoadDb_Upp]    Script Date: 2021/1/8 10:15:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[oceanLoadDb_Upp]
	@sId varchar(36) OUTPUT,
	@type int,
	@keyVal nvarchar(256),
	@json nvarchar(max),
	@xml nvarchar(max),
	@modifyUser varchar(36),
	@sTamp timestamp,
	@error varchar(500) OUTPUT
AS

BEGIN

	declare @procName nvarchar(50),    --存储过程名称
        @language nvarchar(50),    --语言代码
        @position bigint;
	--错误位置
	set @procName = 'oceanLoadDb_Upp';
	set @language = @error;
	set @position = 1;

	select @sId=sId
	from oceanLoadDb
	where type=@type and keyVal=@keyVal;

	begin transaction;
	BEGIN TRY
     if @sId is null
	   begin
		set @sId=lower(newid());
		Insert Into oceanLoadDb
			(
			sId,
			type,
			keyVal,
			json,
			xml,
			createUser,
			createTime,
			modifyUser,
			modifyTime
			)
		Values(
				@sId,
				@type,
				@keyVal,
				@json,
				CONVERT(xml,@xml),
				@modifyUser,
				sysdatetimeoffset(),
				@modifyUser,
				sysdatetimeoffset()
				   );
	end;
	else
	    begin
		Update oceanLoadDb Set
					 json=@json, 
					 xml= CONVERT(xml,@xml), 
					 modifyUser=@modifyUser, 
					 modifyTime=sysdatetimeoffset()
				   WHERE sId=@sId;

		if type=1
			begin
			EXEC oceanLoadDb_Upp_Type1
                   	@sId,
                   	@json,
                   	@xml,
					@createUser,
					@createTime,
					@modifyUser,
					@modifyTime,
					@sTamp,
                   @return_error OUTPUT;
		end;
		else if type=2
			begin

			end;

	end;
     commit transaction;
     set @error='0';
END
	TRY

BEGIN CATCH
	rollback transaction;
	set @error='error:'+ERROR_MESSAGE();
	--set @error = @procName+':'+dbo.SpringSpTranslation_Error(@procName,@language,999,Convert(varchar(150),@position),ERROR_MESSAGE(),'','','');
	END CATCH;

END;


USE [SpringCms]
GO
/****** Object:  StoredProcedure [dbo].[oceanLoadDb_Upp]    Script Date: 2021/1/8 10:15:53 ******/
ALTER PROCEDURE [dbo].[oceanLoadDb_Upp_Type1]
	@sId varchar(36),
	@json nvarchar(max),
	@xml nvarchar(max),
	@modifyUser varchar(36),
	@sTamp timestamp,
	@error varchar(500) OUTPUT
AS

BEGIN
	declare @procName nvarchar(50),    --存储过程名称
        @language nvarchar(50),    --语言代码
        @position bigint,
		@isexist nvarchar(36),
		@TmpXML xml,
		@TmpTitle nvarchar(256),
		@TmpTime datetime,
        @TmpAddress nvarchar(256),
		@TmpRate nvarchar(50),
		@TmpBuildArea nvarchar(256),
		@TmpDescription nvarchar(512),
		@TmpPronum nvarchar(36),
		@TmpProtype nvarchar(36),
		@TmpBuildTime nvarchar(50),
		@TmpProPhase nvarchar(36),
		@TmpArea1 nvarchar(36),
        @TmpArea2 nvarchar(36),
        @TmpArea nvarchar(36),
		@tId varchar(30),
		@createTime datetime;

	set @TmpXML = CONVERT(xml,@xml);
	--错误位置
	set @procName = '[oceanLoadDb_Upp_Type1]';
	set @language = @error;
	set @position = 1;

	begin transaction;
	BEGIN TRY

	set @TmpTitle = @TmpXML.value('(root/name)[1]','nvarchar(256)');-- 标题
	set @TmpTime = CONVERT(NVARCHAR(125), @TmpXML.query('data(/root/titles[code="FBSJ"]/val[1])'));
    set @TmpAddress = CONVERT(NVARCHAR(256), @TmpXML.query('data(/root/titles[code="XMDZ"]/val[1])'));
	set @TmpRate = CONVERT(NVARCHAR(50), @TmpXML.query('data(/root/titles[code="ZTZE"]/val[1])'));
	set @TmpBuildArea = CONVERT(NVARCHAR(256), @TmpXML.query('data(/root/titles[code="JZMJ"]/val[1])'));
	set @TmpDescription = CONVERT(NVARCHAR(512), @TmpXML.query('data(/root/infos[code="XMGK"]/val[1])'));
	set @TmpPronum = CONVERT(NVARCHAR(36), @TmpXML.query('data(/root/titles[code="XMBH"]/val[1])'));
	set @TmpProtype = CONVERT(NVARCHAR(36), @TmpXML.query('data(/root/titles[code="XMLX"]/val[1])'));
	set @TmpBuildTime = CONVERT(NVARCHAR(50), @TmpXML.query('data(/root/titles[code="JSZQ"]/val[1])'));
	set @TmpProPhase = CONVERT(NVARCHAR(36), @TmpXML.query('data(/root/titles[code="XMJD"]/val[1])'));
	set @TmpArea1 = CONVERT(NVARCHAR(36), @TmpXML.query('data(/root/titles[code="SZXS"]/val[1])'));
	set @TmpArea2 = CONVERT(NVARCHAR(36), @TmpXML.query('data(/root/titles[code="SQ"]/val[1])'));
	set @TmpArea = @TmpArea1 + @TmpArea2;
	set @createTime=sysdatetime();
	EXEC dbo.springTimeId @createTime,'eqProject',@tId output;

	set @tmp = CONVERT(NVARCHAR(MAX),@TmpXML.query('data(/root/titles[code="FBSJ"]/val[1])'));

	select @isexist=sign
	from [dbo].[eqProject]
	where sign=@sId

	IF @isexist is null
        BEGIN
        -- insert dbo.eqProject
        Insert Into dbo.eqProject
            (
            sId,
			title,
            time, -- 发布时间
            address, -- 项目地址
            rate, -- 总投资额
            buildArea, -- 建筑面积
            description, -- 项目概况
			state,
			tId,
			sign,
			isDel,
            pronum, -- 编号
            protype, -- 项目类型
            buildtime, -- 建设周期
            prophase, -- 项目阶段
            proarea, -- 地区（省直辖市+市区）
			createTime
            )
        Values(
                lower(newid()),
				@TmpTitle, -- 标题
                @TmpTime, -- 发布时间
                @TmpAddress, -- 项目地址
                @TmpRate, -- 总投资额
                @TmpBuildArea, -- 建筑面积
                @TmpDescription, --
				0,
				@tId,
				@sId,
				0,
                @TmpPronum, -- 编号
                @TmpProtype, -- 项目类型
                @TmpBuildTime, -- 建设周期
                @TmpProPhase, -- 项目阶段
                @TmpArea,  -- 地区（省直辖市+市区）
				@createTime
           );
		-- insert dbo.eqProOther
		declare 
			@cnt INT,
			@toCnt INT,
			@TmpCortype nvarchar(50),
			@TmpTitle nvarchar(50),
			@cnt_users INT,
			@toCnt_users INT;
		select
			@cnt = 1,
			@toCnt =  @x.value('count(/root/contacts)','INT');

		WHILE @cnt <= @toCnt BEGIN
  		SELECT
  		  	@TmpCortype = CONVERT(NVARCHAR(50), C.query('data(name[1])')),
			@TmpTitle = CONVERT(NVARCHAR(50), C.query('data(entname[1])')),
			@cnt_users = 1,
			@toCnt_users = C.value('count(users)','INT')
			from  @x.nodes('/root/contacts[position()=sql:variable("@cnt")]') T(C);
			WHILE @cnt_users <= @toCnt_users BEGIN
			select  
				@TmpName = CONVERT(NVARCHAR(125), C.query('data(users[position()=sql:variable("@cnt_users")]/vals[code="XM"]/val[1])'))
				
			from @x.nodes('/root/contacts[position()=sql:variable("@cnt")]') T(C);
			END;
				
			PRINT 'Processing Child Element: ' + CAST(@cnt AS VARCHAR)
			PRINT 'Child element: ' + CAST(@name AS VARCHAR(100))
			PRINT 'users count: ' + CAST(@toCnt_users AS VARCHAR)
			PRINT ''
			-- incremet the counter variable
			SELECT @cnt = @cnt + 1
		END;

    END;
	ELSE
		BEGIN
        -- update
		     Update dbo.eqProject Set
			 title=@TmpTitle, -- 标题
             time=@TmpTime,
             address=@TmpAddress, -- 项目地址
             rate=@TmpRate,
             buildArea=@TmpBuildArea,
             description=@TmpDescription,
             pronum=@TmpPronum,
             protype=@TmpProtype,
             buildtime=@TmpBuildTime,
             prophase=@TmpProPhase,
             proarea=@TmpArea,
             modifyTime=sysdatetimeoffset()
           WHERE sign=@sId;
        END;
    commit transaction;
    set @error='0';
END TRY

BEGIN CATCH
      rollback transaction;
      set @error='error:'+ERROR_MESSAGE();
      --set @error = @procName+':'+dbo.SpringSpTranslation_Error(@procName,@language,999,Convert(varchar(150),@position),ERROR_MESSAGE(),'','','');
END CATCH;

END;
GO


declare @xml xml,
        @DH varchar(100);
select @xml=xml
from [dbo].[oceanLoadDb]
where sId='b6625561-0c23-485a-9237-6451518488b5'

select @xml;

declare @tab table(
	code nvarchar(125),
	name nvarchar(125),
	val nvarchar(125)
 )

insert @tab
	(code,name,val)
SELECT
	C.value('code[1]','nvarchar(125)') as code,
	C.value('name[1]','nvarchar(125)') as name,
	C.value('val[1]','nvarchar(125)') as val
from @xml.nodes('/root/detail') as T(C);

select @DH=val
from @tab
where code='DH';

select @DH;


-- 开发商子表
CREATE TABLE [dbo].[eqProOther]
(
	[sId] [varchar](36) NULL,
	[pId] [varchar](36) NULL,
	[int1] [int] NULL,
	[type] [int] NULL,
	[title] [nvarchar](50) NULL,
	[contact] [nvarchar](20) NULL,
	[name] [nvarchar](50) NULL,
	[phone] [nvarchar](50) NULL,
	[mobilePhone] [nvarchar](50) NULL,
	[email] [nvarchar](128) NULL,
	[msn] [nvarchar](50) NULL,
	[qq] [nvarchar](50) NULL,
	[site] [nvarchar](50) NULL,
	[address] [nvarchar](50) NULL,
	[remark] [nvarchar](max) NULL,
	[isDel] [bit] NULL,
	[createUser] [nvarchar](50) NULL,
	[createTime] [datetimeoffset](7) NULL,
	[modifyUser] [nvarchar](50) NULL,
	[modifyTime] [datetimeoffset](7) NULL,
	[sTamp] [timestamp] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[eqProOther] ADD  CONSTRAINT [DF_eqProOther_isDel]  DEFAULT ((0)) FOR [isDel]
GO

ALTER TABLE [dbo].[eqProOther] ADD  CONSTRAINT [DF_eqProOther_createTime]  DEFAULT (getdate()) FOR [createTime]
GO

ALTER TABLE [dbo].[eqProOther] ADD  CONSTRAINT [DF_eqProOther_modifyTime]  DEFAULT (getdate()) FOR [modifyTime]
