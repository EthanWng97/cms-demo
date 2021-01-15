USE [SpringCms]
GO
/****** Object:  StoredProcedure [dbo].[oceanLoadDb_Upp]    Script Date: 2021/1/14 16:12:50 ******/
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
        if @type=1
			begin
            EXEC oceanLoadDb_Upp_Type1
                   	@sId,
                   	@json,
                   	@xml,
					@modifyUser,
					@sTamp,
                   @error OUTPUT;
        end;
		else if @type=2
			begin
            EXEC oceanLoadDb_Upp_Type2
                   	@sId,
                   	@json,
                   	@xml,
					@modifyUser,
					@sTamp,
                   @error OUTPUT;
        end;
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