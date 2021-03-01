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
       @dateBox datetimeoffset(7),
       @richTextBox nvarchar(256),
       @dropDownList int,
       @foreignKey varchar(36),
       @dropDownTree int,
       @numberBox decimal(18,2),
       @numberSpinner int,
       @timeSpinner nvarchar(10),
       @dateTimeBox datetimeoffset(7),
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
	declare @TmpXml xml =  CONVERT(xml,@xml);
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
	end;
	if type=1
	begin
		EXEC oceanLoadDb_Upp_Type1
            @sId,
            @json,
            @TmpXml,
			@modifyUser,
            @error OUTPUT;
	end;
	else if type=2
	begin
		EXEC oceanLoadDb_Upp_Type2
            @sId,
          	@json,
        	@TmpXml,
			@modifyUser,
            @error OUTPUT;
	end;
    commit transaction;
    set @error='0';
END TRY

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
	@xml xml,
	@modifyUser varchar(36),
	@error varchar(500) OUTPUT
AS

BEGIN
	declare @procName nvarchar(50),    --存储过程名称
        @language nvarchar(50),    --语言代码
        @position bigint,
		@isexist nvarchar(36),
		@TmpSid nvarchar(36),
		@TmpXML xml,
		@TmpTitle nvarchar(256),
		@TmpTime datetimeoffset(7),
        @TmpAddress nvarchar(256),
		@TmpRate nvarchar(50),
		@TmpBuildArea nvarchar(256),
		@TmpDescription nvarchar(MAX),
		@TmpPronum nvarchar(36),
		@TmpProtype nvarchar(36),
		@TmpBuildTime nvarchar(50),
		@TmpProPhase nvarchar(36),
		@TmpArea1 nvarchar(36),
		@TmpArea2 nvarchar(36),
		@TmpArea nvarchar(36),
		@TmpProgress nvarchar(MAX),
		@TmpBody nvarchar(MAX),
		@tId varchar(30),
		@createTime datetimeoffset(7),

		@cnt INT,
		@toCnt INT,
		@TmpUserCortype nvarchar(50),
		@TmpUserTitle nvarchar(MAX),
		@TmpUserName nvarchar(50),
		@TmpUserQq nvarchar(50),
		@TmpUserMobileP nvarchar(50),
		@TmpUserPhone nvarchar(50),
		@TmpUserAddress nvarchar(50),
		@TmpUserPositio nvarchar(50),
		@TmpUserRemark nvarchar(MAX),
		@cnt_users INT,
		@toCnt_users INT,
		@TmpEdition nvarchar(50),
		@isUserExist nvarchar(36);

	-- set @TmpXML = CONVERT(xml,@xml);
	set @TmpXML = @xml;
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
	set @TmpDescription = CONVERT(NVARCHAR(MAX), @TmpXML.query('data(/root/infos[code="XMGK"]/val[1])'));
	set @TmpPronum = CONVERT(NVARCHAR(36), @TmpXML.query('data(/root/titles[code="XMBH"]/val[1])'));
	set @TmpProtype = CONVERT(NVARCHAR(36), @TmpXML.query('data(/root/titles[code="XMLX"]/val[1])'));
	set @TmpBuildTime = CONVERT(NVARCHAR(50), @TmpXML.query('data(/root/titles[code="JSZQ"]/val[1])'));
	set @TmpProPhase = CONVERT(NVARCHAR(36), @TmpXML.query('data(/root/titles[code="XMJD"]/val[1])'));
	set @TmpArea1 = CONVERT(NVARCHAR(36), @TmpXML.query('data(/root/titles[code="SZXS"]/val[1])'));
	set @TmpArea2 = CONVERT(NVARCHAR(36), @TmpXML.query('data(/root/titles[code="SQ"]/val[1])'));
	set @TmpEdition = CONVERT(NVARCHAR(50), @TmpXML.query('data(/root/BBLX[code="BBLX"]/val[1])'));
	set @TmpProgress = CONVERT(NVARCHAR(MAX), @TmpXML.query('data(/root/infos2[code="JZXQ"]/val[1])'));
	set @TmpBody = '进展详情： '  + @TmpProgress;

	set @TmpArea = @TmpArea1 + @TmpArea2;
	set @createTime=sysdatetimeoffset();
	
	EXEC dbo.springTimeId @createTime,'eqProject',@tId output;

	-- set @tmp = CONVERT(NVARCHAR(MAX),@TmpXML.query('data(/root/titles[code="FBSJ"]/val[1])'));

	select @isexist=sign
	from [dbo].[eqProject]
	where sign=@sId

	IF @isexist is null
    BEGIN
		set @TmpSid = lower(newid());
		-- insert dbo.eqProject
		Insert Into dbo.eqProject
			(
			sId,
			title,
			int1,
			type,
			recom,
			edition,
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
			createTime,
			createUser,
			modifyUser
			)
		Values(
				@TmpSid,
				@TmpTitle, -- 标题
				0,
				1,
				1,
				@TmpEdition,
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
				@TmpArea, -- 地区（省直辖市+市区）
				@createTime,
				@modifyUser,
				@modifyUser
           );
		-- insert into dbo.eqhtmlInfo
		Insert Into dbo.eqhtmlInfo
			(
			sId,
			body
			)
		Values(
				@TmpSid,
				@TmpBody
           );
		-- insert dbo.eqProOther
		select
			@cnt = 1,
			@toCnt =  @TmpXML.value('count(/root/contacts)','INT');

		WHILE @cnt <= @toCnt BEGIN
			SELECT
				@TmpUserCortype = CONVERT(NVARCHAR(50), C.query('data(name[1])')),
				@TmpUserTitle = CONVERT(NVARCHAR(MAX), C.query('data(entname[1])')),
				@cnt_users = 1,
				@toCnt_users = C.value('count(users)','INT')
			from @TmpXML.nodes('/root/contacts[position()=sql:variable("@cnt")]') T(C);
			WHILE @cnt_users <= @toCnt_users BEGIN
				select
					@TmpUserName = CONVERT(NVARCHAR(50), C.query('data(vals[code="XM"]/val[1])')),
					@TmpUserQq = CONVERT(NVARCHAR(50), C.query('data(vals[code="BM"]/val[1])')),
					@TmpUserMobileP = CONVERT(NVARCHAR(50), C.query('data(vals[code="SJ"]/val[1])')),
					@TmpUserPhone = CONVERT(NVARCHAR(50), C.query('data(vals[code="ZJ"]/val[1])')),
					@TmpUserAddress = CONVERT(NVARCHAR(50), C.query('data(vals[code="DZ"]/val[1])')),
					@TmpUserPositio = CONVERT(NVARCHAR(50), C.query('data(vals[code="ZW"]/val[1])')),
					@TmpUserRemark = CONVERT(NVARCHAR(MAX), C.query('data(vals[code="BZ"]/val[1])'))
				from @TmpXML.nodes('/root/contacts[position()=sql:variable("@cnt")]/users[position()=sql:variable("@cnt_users")]') T(C);
				Insert Into dbo.eqProOther
					(
					sId,
					pId,
					title,
					name,
					phone,
					mobilePhone,
					qq,
					positio,
					address,
					cortype,
					remark,
					createTime,
					createUser,
					modifyUser
					)
				Values(
						lower(newid()),
						@TmpSid,
						@TmpUserTitle,
						@TmpUserName,
						@TmpUserPhone,
						@TmpUserMobileP,
						@TmpUserQq,
						@TmpUserPositio,
						@TmpUserAddress,
						@TmpUserCortype,
						@TmpUserRemark,
						@createTime,
						@modifyUser,
						@modifyUser
           );
				SELECT @cnt_users = @cnt_users + 1;
			END;
			-- incremet the counter variable
			SELECT @cnt = @cnt + 1
		END;

	END;
	ELSE
	BEGIN
		select @TmpSid = sId
		from [dbo].[eqProject]
		where sign=@sId;

		-- update dbo.eqProject
		Update dbo.eqProject Set
		title=@TmpTitle,
		edition=@TmpEdition,
        time=@TmpTime,
        address=@TmpAddress,
        rate=@TmpRate,
        buildArea=@TmpBuildArea,
        description=@TmpDescription,
        pronum=@TmpPronum,
        protype=@TmpProtype,
        buildtime=@TmpBuildTime,
        prophase=@TmpProPhase,
        proarea=@TmpArea,
        modifyTime=sysdatetimeoffset(),
		modifyUser=@modifyUser
        WHERE sign=@sId;
		-- update dbo.eqhtmlInfo
		Update dbo.eqhtmlInfo Set
		body=@TmpBody
        WHERE sId=@sId;
		-- update dbo.eqProOther
		select
			@cnt = 1,
			@toCnt =  @TmpXML.value('count(/root/contacts)','INT');

		WHILE @cnt <= @toCnt 
		BEGIN
			SELECT
				@TmpUserCortype = CONVERT(NVARCHAR(50), C.query('data(name[1])')),
				@TmpUserTitle = CONVERT(NVARCHAR(MAX), C.query('data(entname[1])')),
				@cnt_users = 1,
				@toCnt_users = C.value('count(users)','INT')
			from @TmpXML.nodes('/root/contacts[position()=sql:variable("@cnt")]') T(C);
			WHILE @cnt_users <= @toCnt_users BEGIN
				select
					@TmpUserName = CONVERT(NVARCHAR(50), C.query('data(vals[code="XM"]/val[1])')),
					@TmpUserQq = CONVERT(NVARCHAR(50), C.query('data(vals[code="BM"]/val[1])')),
					@TmpUserMobileP = CONVERT(NVARCHAR(50), C.query('data(vals[code="SJ"]/val[1])')),
					@TmpUserPhone = CONVERT(NVARCHAR(50), C.query('data(vals[code="ZJ"]/val[1])')),
					@TmpUserAddress = CONVERT(NVARCHAR(50), C.query('data(vals[code="DZ"]/val[1])')),
					@TmpUserPositio = CONVERT(NVARCHAR(50), C.query('data(vals[code="ZW"]/val[1])')),
					@TmpUserRemark = CONVERT(NVARCHAR(MAX), C.query('data(vals[code="BZ"]/val[1])'))
				from @TmpXML.nodes('/root/contacts[position()=sql:variable("@cnt")]/users[position()=sql:variable("@cnt_users")]') T(C);

				-- insert or update dbo.eqProOther

				select @isUserExist=pId
				from [dbo].[eqProOther]
				where pid=@TmpSid AND name = @TmpUserName;

				IF @isUserExist is null
			BEGIN
					-- insert
					Insert Into dbo.eqProOther
						(
						sId,
						pId,
						title,
						name,
						phone,
						mobilePhone,
						qq,
						positio,
						address,
						cortype,
						remark,
						createTime,
						createUser,
						modifyUser
						)
					Values(
							lower(newid()),
							@TmpSid,
							@TmpUserTitle,
							@TmpUserName,
							@TmpUserPhone,
							@TmpUserMobileP,
							@TmpUserQq,
							@TmpUserPositio,
							@TmpUserAddress,
							@TmpUserCortype,
							@TmpUserRemark,
							@createTime,
							@modifyUser,
							@modifyUser
        	   );
				END;
			ELSE
			BEGIN
					-- update
					Update dbo.eqProOther Set
			 	title=@TmpUserTitle,
        	 	phone=@TmpUserPhone,
        	 	mobilePhone=@TmpUserMobileP,
        	 	qq=@TmpUserQq,
        	 	positio=@TmpUserPositio,
        	 	address=@TmpUserAddress,
        	 	cortype=@TmpUserCortype,
        	 	remark=@TmpUserRemark,
        	 	modifyTime=sysdatetimeoffset(),
				modifyUser=@modifyUser
        	WHERE pId=@TmpSid AND name = @TmpUserName;
				END;

				SELECT @cnt_users = @cnt_users + 1;
			END;
			-- incremet the counter variable
			SELECT @cnt = @cnt + 1
		END;
	END;
    commit transaction;
    set @error='0';
END TRY

BEGIN CATCH
      rollback transaction;
      set @error='error1:'+ERROR_MESSAGE();
      --set @error = @procName+':'+dbo.SpringSpTranslation_Error(@procName,@language,999,Convert(varchar(150),@position),ERROR_MESSAGE(),'','','');
END CATCH;
END;
GO


USE [SpringCms]
GO
/****** Object:  StoredProcedure [dbo].[oceanLoadDb_Upp]    Script Date: 2021/1/8 10:15:53 ******/
ALTER PROCEDURE [dbo].[oceanLoadDb_Upp_Type2]
	@sId varchar(36),
	@json nvarchar(max),
	@xml xml,
	@modifyUser varchar(36),
	@error varchar(500) OUTPUT
AS

BEGIN
	declare @procName nvarchar(50),    --存储过程名称
        @language nvarchar(50),    --语言代码
        @position bigint,
		@isexist nvarchar(36),
		@TmpSid nvarchar(36),
		@TmpXML xml,

		@TmpTitle nvarchar(50),
		@TmpChar1 nvarchar(256),
		@TmpSocode nvarchar(50),
		@TmpIndustry nvarchar(512),
        @TmpDescription nvarchar(MAX),
        @TmpArea nvarchar(MAX),
        @TmpBody nvarchar(MAX),
        @TmpSetupTime nvarchar(50),
		@TmpCapital nvarchar(50),
		@tId varchar(30),
		@createTime datetimeoffset(7),

		@TmpUserPhone nvarchar(50),
		@TmpUserEmail nvarchar(128),
		@TmpUserAddress nvarchar(50),
		@TmpUserName nvarchar(50),

        @TmpStaffContact nvarchar(50),
        @TmpStaffDepart nvarchar(50), 

        @cnt INT,
		@toCnt INT,
        @isStaffExist nvarchar(36),
		@isUserExist nvarchar(36);

	-- set @TmpXML = CONVERT(xml,@xml);
	set @TmpXML = @xml;
	--错误位置
	set @procName = '[oceanLoadDb_Upp_Type2]';
	set @language = @error;
	set @position = 1;

	begin transaction;
	BEGIN TRY

	set @TmpTitle = @TmpXML.value('(root/name)[1]','nvarchar(256)');
	set @TmpChar1 = CONVERT(NVARCHAR(256), @TmpXML.query('data(/root/detail[code="WZ"]/val[1])'));
	set @TmpDescription = CONVERT(NVARCHAR(MAX), @TmpXML.query('data(/root/detail[code="summary"]/val[1])'));
	set @TmpArea = CONVERT(NVARCHAR(MAX), @TmpXML.query('data(/root/baseInfo[code="JYFW"]/val[1])'));
	set @TmpSocode = CONVERT(NVARCHAR(50), @TmpXML.query('data(/root/baseInfo[code="TYSHXYDM"]/val[1])'));
	set @TmpIndustry = CONVERT(NVARCHAR(512), @TmpXML.query('data(/root/baseInfo[code="HY"]/val[1])'));
	set @TmpBody = '简介： ' + @TmpDescription + CHAR(10) + '经营范围： '  + @TmpArea;
	set @TmpSetupTime = CONVERT(NVARCHAR(125), @TmpXML.query('data(/root/baseInfo[code="CLRQ"]/val[1])'));
	set @TmpCapital = CONVERT(NVARCHAR(50), @TmpXML.query('data(/root/baseInfo[code="ZCZB"]/val[1])'));

 	set @createTime=sysdatetimeoffset();
	
	EXEC dbo.springTimeId @createTime,'cmsBrand',@tId output;

    set @TmpUserPhone= CONVERT(NVARCHAR(125), @TmpXML.query('data(/root/detail[code="DH"]/val[1])'));
    set @TmpUserEmail= CONVERT(NVARCHAR(125), @TmpXML.query('data(/root/detail[code="YX"]/val[1])'));
    set @TmpUserAddress= CONVERT(NVARCHAR(125), @TmpXML.query('data(/root/detail[code="DZ"]/val[1])'));
    set @TmpUserName= CONVERT(NVARCHAR(125), @TmpXML.query('data(/root/baseInfo[code="FDDBR"]/val[1])'));

	select @isexist=sign
	from [dbo].[cmsBrand]
	where sign=@sId

	IF @isexist is null
    BEGIN
		set @TmpSid = lower(newid());
		-- insert dbo.cmsBrand
		Insert Into dbo.cmsBrand
			(
			sId,
			title,
			socode,
			industry,
			char1,
			body,
			setUpTime,
			tId,
			sign,
			capital,
			isDel,
			recom,
			pptj,
			sytj,
			type,
			createTime,
			createUser,
			modifyUser
			)
		Values(
				@TmpSid,
				@TmpTitle,
				@TmpSocode,
				@TmpIndustry,
				@TmpChar1,
				@TmpBody,
				@TmpSetupTime,
				@tId,
				@sId,
				@TmpCapital,
				1,
				0,
				0,
				0,
				1,
				@createTime,
				@modifyUser,
				@modifyUser
           );
		-- insert dbo.cmsBrandPeop
		Insert Into dbo.cmsBrandPeop
			(
			sId,
			pId,
			title,
			name,
			phone,
			email,
			address,
			createTime,
			createUser,
			modifyUser
			)
		Values(
				lower(newid()),
				@TmpSid,
				@TmpTitle,
				@TmpUserName,
				@TmpUserPhone,
				@TmpUserEmail,
				@TmpUserAddress,
				@createTime,
				@modifyUser,
				@modifyUser
           );

		-- insert into dbo.cmsBrandPeop with container_staff
		select
			@cnt = 1,
			@toCnt =  @TmpXML.value('count(/root/container_staff)','INT');
		WHILE @cnt <= @toCnt 
        BEGIN
			SELECT
				@TmpStaffContact = CONVERT(NVARCHAR(50), C.query('data(NAME[1])')),
				@TmpStaffDepart = CONVERT(NVARCHAR(50), C.query('data(ZW[1])'))
			from @TmpXML.nodes('/root/container_staff[position()=sql:variable("@cnt")]') T(C);
			Insert Into dbo.cmsBrandPeop
				(
				sId,
				pId,
				title,
				contact,
				department,
				createTime,
				createUser,
				modifyUser
				)
			Values(
					lower(newid()),
					@TmpSid,
					@TmpTitle,
					@TmpStaffContact,
					@TmpStaffDepart,
					@createTime,
					@modifyUser,
					@modifyUser
               );
			SELECT @cnt = @cnt + 1
		END;
	END;
	ELSE
	BEGIN
		select @TmpSid = sId
		from [dbo].[cmsBrand]
		where sign=@sId;

		-- update dbo.cmsBrand
		Update dbo.cmsBrand Set
		title=@TmpTitle,
		socode=@TmpSocode,
		industry=@TmpIndustry,
        char1=@TmpChar1,
        body=@TmpBody,
        setUpTime=@TmpSetupTime,
        tId=@tId,
		capital=@TmpCapital,
        modifyTime=sysdatetimeoffset(),
		modifyUser=@modifyUser
        WHERE sign=@sId;
		-- insert or update dbo.cmsBrandPeop

		select @isUserExist=pId
		from [dbo].[cmsBrandPeop]
		where pid=@TmpSid AND name = @TmpUserName;

		IF @isUserExist is null
			BEGIN
			-- insert
			Insert Into dbo.cmsBrandPeop
				(
				sId,
				pId,
				title,
				name,
				phone,
				email,
				address,
				createTime,
				createUser,
				modifyUser
				)
			Values(
					lower(newid()),
					@TmpSid,
					@TmpTitle,
					@TmpUserName,
					@TmpUserPhone,
					@TmpUserEmail,
					@TmpUserAddress,
					@createTime,
					@modifyUser,
					@modifyUser
        	   );
		END;
			ELSE
			BEGIN
			-- update
			Update dbo.cmsBrandPeop Set
        	 	phone=@TmpUserPhone,
        	 	email=@TmpUserEmail,
        	 	address=@TmpUserAddress,
        	 	modifyTime=sysdatetimeoffset(),
				modifyUser=@modifyUser
        	WHERE pId=@TmpSid AND name = @TmpUserName;
		END;

		-- insert into or update dbo.cmsBrandPeop with container_staff
		select
			@cnt = 1,
			@toCnt =  @TmpXML.value('count(/root/container_staff)','INT');
		WHILE @cnt <= @toCnt 
        BEGIN
			SELECT
				@TmpStaffContact = CONVERT(NVARCHAR(50), C.query('data(NAME[1])')),
				@TmpStaffDepart = CONVERT(NVARCHAR(50), C.query('data(ZW[1])'))
			from @TmpXML.nodes('/root/container_staff[position()=sql:variable("@cnt")]') T(C);

			select @isStaffExist=pId
			from [dbo].[cmsBrandPeop]
			where pid=@TmpSid AND contact = @TmpStaffContact;
			IF @isStaffExist is null
			BEGIN
				Insert Into dbo.cmsBrandPeop
					(
					sId,
					pId,
					title,
					contact,
					department,
					createTime,
					createUser,
					modifyUser
					)
				Values(
						lower(newid()),
						@TmpSid,
						@TmpTitle,
						@TmpStaffContact,
						@TmpStaffDepart,
						@createTime,
						@modifyUser,
						@modifyUser
                   );
			END;
            ELSE
            BEGIN
				Update dbo.cmsBrandPeop Set
        	     	department=@TmpStaffDepart,
        	     	modifyTime=sysdatetimeoffset(),
			    	modifyUser=@modifyUser
        	    WHERE pId=@TmpSid AND contact = @TmpStaffContact;
			END;
			SELECT @cnt = @cnt + 1
		END;
	END;
    commit transaction;
    set @error='0';
END TRY

BEGIN CATCH
      rollback transaction;
      set @error='error2:'+ERROR_MESSAGE();
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


USE [Ocean]
GO
/****** Object:  StoredProcedure [dbo].[springTb_Upp]    Script Date: 26/2/2021 下午 3:24:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[springTb_Upp]
	@sId varchar(36),
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
	@remark nvarchar(MAX),
	@modifyUser nvarchar(50),
	@sTamp timestamp,
	@error nvarchar(500) OUTPUT
AS

BEGIN
	declare @procName nvarchar(50),    --存储过程名称
        @language nvarchar(50), --语言
        @position bigint;
	--错误位置
	set @procName = 'springTb_Upp';
	set @language = @error;
	set @position = 1;

	declare
        @pId varchar(36),
        @ctbType varchar(36);
	select @pId = pId
	from springTb
	where sId=@sId;

	--判断与父项的连接是否允许----------
	exec dbo.SpringCheckRel2 'springTb','tbType',@pId,@tbType,@error output;
	if @error != '0'
	return;
	set @error = @language;
	-------------------------------------
	--判断与子项的连接是否允许-----------
	DECLARE table_cur CURSOR FOR
	select tbType
	from springTb
	where pId=@sId;
	OPEN table_cur;
	FETCH NEXT FROM table_cur INTO @ctbType;
	WHILE @@fetch_status = 0
	BEGIN
		exec dbo.SpringCheckRel 'springTb','tbType',@tbType,@CtbType,@error output;
		if @error != '0'
			begin
			CLOSE table_cur;
			DEALLOCATE table_cur;
			return;
		end;
		set @error = @language;
		FETCH NEXT FROM table_cur INTO @ctbType;
	END;
	CLOSE table_cur;
	DEALLOCATE table_cur;
	------------------------------------

	--表名默认与名称相同
	if @tbType=1 and @tbName is null	
	set @tbName=@name;
	if @tbType=1 and @storedProcName is null 	
	set @storedProcName=@tbName + '_Action';


	set @error = '';
	if @name='' or @name is null   -- 名称不能为空...
	begin
		set @position = 1;
		set @error=dbo.SpringSpTranslation_Error(@procName,@language,@position,'','','','','');
		return;
	end;

	if @tbType=1 -- 名称已经存在
	begin
		if exists (select *
		from SpringTb
		where sId!=@sId and tbType=1 and name=@name)
	    	begin
			set @position = 2;
			if @error=''
					set @error=dbo.SpringSpTranslation_Error(@procName,@language,@position,@name,'','','','');
			    else
			    	set @error=@error+char(10)+dbo.SpringSpTranslation_Error(@procName,@language,@position,@name,'','','','');
		end;
	end;

	if @error!=''
	return;


	begin transaction;

	BEGIN TRY
     Update springTb set
			tbType=@tbType,
			name=@name,
			shortName=@shortName,
			description=@description,
			descriptionEn=@descriptionEn,
			tbName=@tbName,
			fieldName=@fieldName,
			fieldNo=@fieldNo,
			isFile=@isFile,
			filePathNo=@filePathNo,
			storedProcName=@storedProcName,
			remark=@remark,
			modifyUser=@modifyUser,
			modifyTime=sysdatetimeoffset()
         where sId=@sId;    
     commit transaction;
      
     set @error='0';
END TRY

BEGIN CATCH
      rollback transaction;
      --set @error='error:'+ERROR_MESSAGE();
      set @error = dbo.SpringSpTranslation_Error(@procName,@language,999,Convert(varchar(150),@position),ERROR_MESSAGE(),'','','');
END CATCH;

END;


SET ANSI_NULLS OFF


USE [OceanCms]
GO
/****** Object:  StoredProcedure [dbo].[springCheckRel]    Script Date: 1/3/2021 上午 10:41:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		ocean
-- Create date: 20121020
-- Description:	判断关联是否合法
--              用在修改中，判断当前的修改是否影响与子节点的关联
--表名、分类类型、父类型值,子类型值、返回值
-- =============================================
ALTER PROCEDURE [dbo].[springCheckRel]
	    @editTbName nvarchar(50),
        @typeName nvarchar(50),
        @pType bigint,
        @cType bigint,
        @error nvarchar(500) output
AS
BEGIN



declare @procName nvarchar(50),    --存储过程名称
        @language nvarchar(50),    --语言代码
        @position bigint;          --错误位置
set @procName = 'SpringCheckRel';
set @language = @error;
set @position = 1;

DECLARE @Count int;

DECLARE @PName nvarchar(50),
        @CName nvarchar(50);

select @editTbName,@typeName,@pType,@cType

--如果REL定义为空，不判断关联
select @Count = count(*) from dbo.springTbTypeRel where tbID in 
			 (select sId from dbo.springTb where Name = @editTbName);
if @Count =0
begin
	set @error = '0';
	return;
end;

if (@pType is null and @cType is null)
	select @Count = count(*) from dbo.springTbTypeRel where tbID in 
				 (select sId from dbo.springTb where Name = @editTbName)
				 and pNO is null and cNO is null;
else if (@pType is null and not(@cType is null))
	select @Count = count(*) from dbo.springTbTypeRel where tbID in 
				 (select sId from dbo.springTb where Name = @editTbName)
				 and pNO is null and cNO = @cType;
else if (not(@pType is null) and @cType is null)
	select @Count = count(*) from dbo.springTbTypeRel where tbID in 
				 (select sId from dbo.springTb where Name = @editTbName)
				 and pNO= @pType and cNO is null;
else
	select @Count = count(*) from dbo.springTbTypeRel where tbID in 
				 (select sId from dbo.springTb where Name = @editTbName)
				 and pNO = @pType and cNO = @cType;
    
if @Count = 0
   begin
       if @pType is null
           set @pName = 'Root';
       else
		   set @pName=dbo.SpringFdNameByNo(@language,@editTbName,@typeName,@pType);
	   
       set @CName = dbo.SpringFdNameByNo(@language,@editTbName,@typeName,@cType);
       --不能添加[PName->CName]的连接...
        set @error =  dbo.SpringSpTranslation_Error(@procName,@language,@position,@PName,@CName,'','','');
   end;
else
   set @error = '0';
END


USE [OceanCms]
GO
/****** Object:  StoredProcedure [dbo].[springCheckRel2]    Script Date: 1/3/2021 上午 10:43:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		ocean
-- Create date: 20121020
-- Description:	判断当前修改的节点与父亲的关联是否合法
--              用在添加、修改、粘贴处理中
--表名、分类类型、父ID,子类型值、返回值
-- =============================================
ALTER PROCEDURE [dbo].[springCheckRel2]
	    @editTbName nvarchar(50),
        @typeName nvarchar(50),
        @pId varchar(36),
        @cType bigint,
        @error nvarchar(500) output
AS
BEGIN

declare @procName nvarchar(50),    --存储过程名称
        @language nvarchar(50),    --语言代码
        @position bigint;          --错误位置
set @procName = 'SpringCheckRel2';
set @language = @error;
set @position = 1;


DECLARE @pType bigint,
        @sql nvarchar(4000),
        @Count int;

if @pId is null
	set @pType = null;
else
    begin
		set @sql = 'select @pType=' + @typeName + ' from ' + @editTbName + ' where sId=''' + @pId +'''';
        EXEC sp_executesql @sql,N'@pType bigint output',@pType output;
    end;

exec dbo.SpringCheckRel
	    @editTbName,
        @typeName,
        @pType,
        @cType,
        @error output;
END


USE [OceanCms]
GO
/****** Object:  UserDefinedFunction [dbo].[SpringSpTranslation_Error]    Script Date: 1/3/2021 上午 10:47:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		dengzw
-- Create date: 2010-02-28
-- Description:	根据存储过程名称，国家编码，位置，5个添加的变量，取得返回错误提示
-- 约定：存储过程中@error默认输入的是国家代码
-- =============================================
ALTER FUNCTION [dbo].[SpringSpTranslation_Error] 
(
	@procName nvarchar(50),
    @language nvarchar(50),
    @position bigint,
    @errAdd1 nvarchar(255),
	@errAdd2 nvarchar(255),
	@errAdd3 nvarchar(255),
	@errAdd4 nvarchar(255),
	@errAdd5 nvarchar(255)
)
RETURNS nvarchar(500)
AS
BEGIN
    if @language =''
		set @language=null;
		
	if @errAdd1 is null
	   set @errAdd1='';
	if @errAdd2 is null
	   set @errAdd2='';
	if @errAdd3 is null
	   set @errAdd3='';
	if @errAdd4 is null
	   set @errAdd4='';
	if @errAdd5 is null
	   set @errAdd5='';


	-- 取得语言编码
	DECLARE @errInfo1 nvarchar(255),
			@errInfo2 nvarchar(255),
			@errInfo3 nvarchar(255),
			@errInfo4 nvarchar(255),
			@errInfo5 nvarchar(255),
            @Return nvarchar(500),
            @isEdit bit;
            
    select @isEdit=isEdit from dbo.springDbInfo;
    if  @isEdit is null
        set @isEdit=0;

    if @language is null
		select  @errInfo1 = errInfo1,
				@errInfo2 = errInfo2,
				@errInfo3 = errInfo3,
				@errInfo4 = errInfo4,
				@errInfo5 = errInfo5
			from    dbo.springSpTranslation sptrn 
				inner join dbo.SpringSp sp on sptrn.spId=sp.sId
			where  sp.name=@procName and sptrn.language is null and sptrn.Position = @position;
    else
		select  @errInfo1 = errInfo1,
				@errInfo2 = errInfo2,
				@errInfo3 = errInfo3,
				@errInfo4 = errInfo4,
				@errInfo5 = errInfo5
			from    dbo.springSpTranslation sptrn 
				inner join dbo.SpringSp sp on sptrn.spId=sp.sId
			where  sp.name=@procName and sptrn.language = @language and sptrn.Position = @position;
    
   DECLARE  @languageCode nvarchar(50);
    
    if @errInfo1 is null and @errInfo2 is null and @errInfo3 is null and @errInfo4 is null and @errInfo5 is null
		begin
		    if @language is null
				set @language='默认';

				return 'Stored procedure['+@procName+']:language['+@language+',]position[' + Convert(nvarchar(50),@position)+'],Undefined Translation!';	
        end;
        
        
	if @errInfo1 is null
		set @errInfo1 = '';
	if @errInfo2 is null
		set @errInfo2 = '';
	if @errInfo3 is null
		set @errInfo3 = '';
	if @errInfo4 is null
		set @errInfo4 = '';
	if @errInfo5 is null
		set @errInfo5 = '';
    
   if @isEdit=1 
	   set @Return = 'Stored procedure['+@procName+']:' + @errInfo1 + @errAdd1 + @errInfo2 + @errAdd2 + @errInfo3 + @errAdd3 +@errInfo4 + @errAdd4 + @errInfo5 + @errAdd5;
   else	 
       set @Return = @errInfo1 + @errAdd1 + @errInfo2 + @errAdd2 + @errInfo3 + @errAdd3 +@errInfo4 + @errAdd4 + @errInfo5 + @errAdd5;  

   return @Return;
END


USE [OceanCms]
GO

/****** Object:  Table [dbo].[springTbTypeRel]    Script Date: 1/3/2021 上午 10:52:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[springTbTypeRel]
(
	[sId] [varchar](36) NOT NULL,
	[tbId] [varchar](36) NULL,
	[pNo] [bigint] NULL,
	[cNo] [bigint] NULL,
	[name] [nvarchar](50) NULL,
	[description] [nvarchar](256) NULL,
	[descriptionEn] [nvarchar](256) NULL,
	[Remark] [nvarchar](max) NULL,
	[queue] [bigint] NULL,
	[createUser] [varchar](36) NULL,
	[createTime] [datetimeoffset](7) NULL,
	[modifyUser] [varchar](36) NULL,
	[modifyTime] [datetimeoffset](7) NULL,
	[sTamp] [timestamp] NULL,
	CONSTRAINT [PK_Sys_Type_Rel] PRIMARY KEY CLUSTERED 
(
	[sId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[springTbTypeRel] ADD  CONSTRAINT [DF_springTypeRel_createTime]  DEFAULT (getdate()) FOR [createTime]
GO

ALTER TABLE [dbo].[springTbTypeRel] ADD  CONSTRAINT [DF_springTypeRel_modifyTime]  DEFAULT (getdate()) FOR [modifyTime]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'介绍' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'springTbTypeRel', @level2type=N'COLUMN',@level2name=N'description'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'中文介绍' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'springTbTypeRel', @level2type=N'COLUMN',@level2name=N'descriptionEn'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'备注' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'springTbTypeRel', @level2type=N'COLUMN',@level2name=N'Remark'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'显示顺序' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'springTbTypeRel', @level2type=N'COLUMN',@level2name=N'queue'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建人' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'springTbTypeRel', @level2type=N'COLUMN',@level2name=N'createUser'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'springTbTypeRel', @level2type=N'COLUMN',@level2name=N'createTime'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'修改人' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'springTbTypeRel', @level2type=N'COLUMN',@level2name=N'modifyUser'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'修改时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'springTbTypeRel', @level2type=N'COLUMN',@level2name=N'modifyTime'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'时间戳' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'springTbTypeRel', @level2type=N'COLUMN',@level2name=N'sTamp'
GO


USE [OceanCms]
GO

/****** Object:  Table [dbo].[springDbInfo]    Script Date: 1/3/2021 上午 10:57:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[springDbInfo](
	[sId] [varchar](36) NOT NULL,
	[sysDB] [bit] NULL,
	[name] [nvarchar](50) NULL,
	[description] [nvarchar](256) NULL,
	[descriptionEn] [nvarchar](256) NULL,
	[Version] [nvarchar](256) NULL,
	[isEdit] [bit] NULL,
 CONSTRAINT [PK_springDbInfo] PRIMARY KEY CLUSTERED 
(
	[sId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'系统数据库，1-是,0-否' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'springDbInfo', @level2type=N'COLUMN',@level2name=N'sysDB'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'数据库名称' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'springDbInfo', @level2type=N'COLUMN',@level2name=N'name'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'数据库描述' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'springDbInfo', @level2type=N'COLUMN',@level2name=N'description'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'数据库英文描述' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'springDbInfo', @level2type=N'COLUMN',@level2name=N'descriptionEn'
GO


USE [OceanCms]
GO

/****** Object:  Table [dbo].[springSpTranslation]    Script Date: 1/3/2021 上午 10:59:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[springSpTranslation](
	[sId] [varchar](36) NOT NULL,
	[spId] [varchar](36) NULL,
	[language] [bigint] NULL,
	[position] [bigint] NULL,
	[description] [nvarchar](256) NULL,
	[descriptionEn] [nvarchar](256) NULL,
	[errInfo1] [nvarchar](256) NULL,
	[errAdd1] [nvarchar](256) NULL,
	[errInfo2] [nvarchar](256) NULL,
	[errAdd2] [nvarchar](256) NULL,
	[errInfo3] [nvarchar](256) NULL,
	[errAdd3] [nvarchar](256) NULL,
	[errInfo4] [nvarchar](256) NULL,
	[errAdd4] [nvarchar](256) NULL,
	[errInfo5] [nvarchar](256) NULL,
	[errAdd5] [nvarchar](256) NULL,
	[queue] [int] NULL,
	[createUser] [varchar](36) NULL,
	[createTime] [datetimeoffset](7) NULL,
	[modifyUser] [varchar](36) NULL,
	[modifyTime] [datetimeoffset](7) NULL,
	[sTamp] [timestamp] NULL,
 CONSTRAINT [PK_Sys_StoredProc_Translation] PRIMARY KEY CLUSTERED 
(
	[sId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[springSpTranslation] ADD  CONSTRAINT [DF_springSpTranslation_createTime]  DEFAULT (getdate()) FOR [createTime]
GO

ALTER TABLE [dbo].[springSpTranslation] ADD  CONSTRAINT [DF_springSpTranslation_modifyTime]  DEFAULT (getdate()) FOR [modifyTime]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'存储过程' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'springSpTranslation', @level2type=N'COLUMN',@level2name=N'spId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'语言内码' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'springSpTranslation', @level2type=N'COLUMN',@level2name=N'language'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'位置' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'springSpTranslation', @level2type=N'COLUMN',@level2name=N'position'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'介绍' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'springSpTranslation', @level2type=N'COLUMN',@level2name=N'description'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'介绍' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'springSpTranslation', @level2type=N'COLUMN',@level2name=N'descriptionEn'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'说明1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'springSpTranslation', @level2type=N'COLUMN',@level2name=N'errInfo1'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'加入1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'springSpTranslation', @level2type=N'COLUMN',@level2name=N'errAdd1'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'说明2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'springSpTranslation', @level2type=N'COLUMN',@level2name=N'errInfo2'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'加入2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'springSpTranslation', @level2type=N'COLUMN',@level2name=N'errAdd2'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'说明3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'springSpTranslation', @level2type=N'COLUMN',@level2name=N'errInfo3'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'加入3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'springSpTranslation', @level2type=N'COLUMN',@level2name=N'errAdd3'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'说明4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'springSpTranslation', @level2type=N'COLUMN',@level2name=N'errInfo4'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'加入4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'springSpTranslation', @level2type=N'COLUMN',@level2name=N'errAdd4'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'说明5' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'springSpTranslation', @level2type=N'COLUMN',@level2name=N'errInfo5'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'加入5' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'springSpTranslation', @level2type=N'COLUMN',@level2name=N'errAdd5'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'排序' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'springSpTranslation', @level2type=N'COLUMN',@level2name=N'queue'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建人' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'springSpTranslation', @level2type=N'COLUMN',@level2name=N'createUser'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'springSpTranslation', @level2type=N'COLUMN',@level2name=N'createTime'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'修改人' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'springSpTranslation', @level2type=N'COLUMN',@level2name=N'modifyUser'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'修改时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'springSpTranslation', @level2type=N'COLUMN',@level2name=N'modifyTime'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'时间戳' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'springSpTranslation', @level2type=N'COLUMN',@level2name=N'sTamp'
GO



USE [OceanCms]
GO

/****** Object:  Table [dbo].[springSp]    Script Date: 1/3/2021 上午 11:04:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[springSp]
(
	[sId] [varchar](36) NOT NULL,
	[tbId] [varchar](36) NOT NULL,
	[name] [nvarchar](50) NOT NULL,
	[description] [nvarchar](256) NULL,
	[descriptionEn] [nvarchar](256) NULL,
	[type] [int] NULL,
	[remark] [nvarchar](max) NULL,
	[queue] [int] NULL,
	[createUser] [varchar](36) NULL,
	[createTime] [datetimeoffset](7) NULL,
	[modifyUser] [varchar](36) NULL,
	[modifyTime] [datetimeoffset](7) NULL,
	[sTamp] [timestamp] NULL,
	CONSTRAINT [PK_Sys_StoredProcedures] PRIMARY KEY CLUSTERED 
(
	[sId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[springSp] ADD  CONSTRAINT [DF_SpringSp_createTime]  DEFAULT (getdate()) FOR [createTime]
GO

ALTER TABLE [dbo].[springSp] ADD  CONSTRAINT [DF_SpringSp_modifyTime]  DEFAULT (getdate()) FOR [modifyTime]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'自增主键' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'springSp', @level2type=N'COLUMN',@level2name=N'sId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'对应表的ID号' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'springSp', @level2type=N'COLUMN',@level2name=N'tbId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'名称' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'springSp', @level2type=N'COLUMN',@level2name=N'name'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'介绍' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'springSp', @level2type=N'COLUMN',@level2name=N'description'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'中文介绍' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'springSp', @level2type=N'COLUMN',@level2name=N'descriptionEn'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'存储过程类型' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'springSp', @level2type=N'COLUMN',@level2name=N'type'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'备注' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'springSp', @level2type=N'COLUMN',@level2name=N'remark'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'排序' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'springSp', @level2type=N'COLUMN',@level2name=N'queue'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建人' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'springSp', @level2type=N'COLUMN',@level2name=N'createUser'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'springSp', @level2type=N'COLUMN',@level2name=N'createTime'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'修改人' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'springSp', @level2type=N'COLUMN',@level2name=N'modifyUser'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'修改时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'springSp', @level2type=N'COLUMN',@level2name=N'modifyTime'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'时间戳' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'springSp', @level2type=N'COLUMN',@level2name=N'sTamp'
GO


