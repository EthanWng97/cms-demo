USE [SpringCms]
GO
/****** Object:  StoredProcedure [dbo].[oceanLoadDb_Upp_Type2]    Script Date: 2021/2/2 13:19:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
			type,
			isDel,
			recom,
			pptj,
			sytj,
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
