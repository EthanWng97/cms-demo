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
        @position bigint;          --错误位置
set @procName = 'ab_test_control_Add';
set @language = @error;
set @position = 1;

begin transaction;

BEGIN TRY
     set @sId=lower(newid()); 
     Insert Into ab_test_control(
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
        @position bigint;          --错误位置
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
        @position bigint;          --错误位置
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