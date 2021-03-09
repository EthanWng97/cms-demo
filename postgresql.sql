CREATE or REPLACE PROCEDURE dbo.ab_test_control_Add(
    INOUT sId varchar(36),
    IN textBox varchar(50),
    IN checkBox BOOLEAN,
    IN dateBox timestamp with time zone,
    IN richTextBox varchar(256),
    IN dropDownList int,
    IN foreignKey varchar(36),
    IN dropDownTree int,
    IN numberBox decimal(18,2),
    IN numberSpinner int,
    IN timeSpinner varchar(10),
    IN dateTimeBox timestamp with time zone,
    IN userId varchar(36),
    IN userName varchar,
    INOUT error varchar,
    INOUT eInfo varchar
)
AS $$

DECLARE 
    procName varchar(50) := 'ab_test_control_Add';    --存储过程名称
    language varchar(50):= error;    --语言代码
    position bigint := 1;     --错误位置

BEGIN
    sId:=uuid_generate_v4();
    -- RAISE NOTICE 'add function: 1';
    Insert Into dbo.ab_test_control
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
        creataUserName,
        createTime,
        modifyUser,
        modifyTime,
        stamp
    )
    values
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
        userId,
        userName,
        now(),
        userId,
        now(),
        now()
    );
    error:='00000';
    eInfo:= 'successful add';
    exception
        When Others Then
            rollback;
            get stacked diagnostics eInfo:= MESSAGE_TEXT,
                                    error:= RETURNED_SQLSTATE;
            eInfo:= concat('error in add procedure: ',eInfo);
            --   error := procName+':'+dbo.SpringSpTranslation_Error(procName,@language,999,Convert(varchar(150),@position),ERROR_MESSAGE(),'','','');
    COMMIT;
END;
$$ LANGUAGE plpgsql;

CREATE PROCEDURE dbo.ab_test_control_Del(
    INOUT sId_tmp varchar(36),
    IN modifyUser varchar,
    INOUT error varchar,
    INOUT eInfo varchar
)
AS $$

DECLARE 
    procName varchar(50) := 'ab_test_control_Del';    --存储过程名称
    language varchar(50):= error;    --语言代码
    position bigint := 1;     --错误位置

BEGIN
    DELETE FROM dbo.ab_test_control WHERE sId=sId_tmp;
    error:='00000';
    eInfo:= 'successful delete';
    exception
        When Others Then
            rollback;
            get stacked diagnostics eInfo:= MESSAGE_TEXT,
                                    error:= RETURNED_SQLSTATE;
            eInfo:= concat('error in delete procedure: ',eInfo);
            --   error := procName+':'+dbo.SpringSpTranslation_Error(procName,@language,999,Convert(varchar(150),@position),ERROR_MESSAGE(),'','','');
    COMMIT;
END;
$$ LANGUAGE plpgsql;

CREATE or REPLACE PROCEDURE dbo.ab_test_control_Upp(
    INOUT sId_tmp varchar(36),
    IN textBox_tmp varchar(50),
    IN checkBox_tmp BOOLEAN,
    IN dateBox_tmp timestamp with time zone,
    IN richTextBox_tmp varchar(256),
    IN dropDownList_tmp int,
    IN foreignKey_tmp varchar(36),
    IN dropDownTree_tmp int,
    IN numberBox_tmp decimal(18,2),
    IN numberSpinner_tmp int,
    IN timeSpinner_tmp varchar(10),
    IN dateTimeBox_tmp timestamp with time zone,
    IN modifyUser_tmp varchar(36),
    INOUT error varchar,
    INOUT eInfo varchar
)
AS $$

DECLARE 
    procName varchar(50) := 'ab_test_control_Del';    --存储过程名称
    language varchar(50):= error;    --语言代码
    position bigint := 1;     --错误位置

BEGIN
    Update dbo.ab_test_control Set
        textBox=textBox_tmp,
        checkBox=checkBox_tmp,
        dateBox=dateBox_tmp,
        richTextBox=richTextBox_tmp,
        dropDownList=dropDownList_tmp,
        foreignKey=foreignKey_tmp,
        dropDownTree=dropDownTree_tmp,
        numberBox=numberBox_tmp,
        numberSpinner=numberSpinner_tmp,
        timeSpinner=timeSpinner_tmp,
        dateTimeBox=dateTimeBox_tmp,
        modifyUser=modifyUser_tmp,
        modifyTime=now(),
        stamp=now()
        WHERE sId=sId_tmp;
    error:='00000';
    eInfo:= 'successful update';
    exception
        When Others Then
            rollback;
            get stacked diagnostics eInfo:= MESSAGE_TEXT,
                                    error:= RETURNED_SQLSTATE;
            eInfo:= concat('error in update procedure: ',eInfo);
            --   error := procName+':'+dbo.SpringSpTranslation_Error(procName,@language,999,Convert(varchar(150),@position),ERROR_MESSAGE(),'','','');
    COMMIT;
END;
$$ LANGUAGE plpgsql;

CREATE or REPLACE PROCEDURE dbo.ab_test_control_Action(
    IN userId varchar,      -- which user call the stored procedure
    IN userName varchar,    -- user name
    INOUT info jsonb,       -- input of action and details, output of result
    INOUT entity varchar,   -- extra info
    INOUT error varchar,    -- error code
	INOUT eInfo varchar     -- error details
)
AS $$

DECLARE
	procName varchar := 'ab_test_control_Action';  --存储过程名称
    language varchar := error; --国家代码
    position bigint := -1;		--错误位置
    return_error varchar;
    return_eInfo varchar;
  	rowinfo jsonb;
    action varchar;
    sId varchar(36);
    rowoutput jsonb;
    -- parameter list
    textBox varchar;
    checkBox boolean;
    dateBox timestamp with time zone;
    richTextBox varchar;
    dropDownList int;
    foreignKey varchar;
    dropDownTree int;
    numberBox decimal(18,2);
    numberSpinner int;
    timeSpinner varchar;
    dateTimeBox timestamp with time zone;
    sTamp timestamp with time zone;
    -- parameter list

BEGIN
    --定义返回JSON临时表
    CREATE TEMP TABLE OutInfo 
        (
        action varchar(20),
        sId varchar(36),
        error varchar, 
        eInfo varchar
        );
    FOR rowinfo in SELECT * FROM jsonb_array_elements(info)
        LOOP
            -- RAISE NOTICE '%',rowinfo;

            -- parameter assignment
            action := rowinfo->>'action';
            sId := rowinfo->>'sId';
            textBox := rowinfo->>'textBox';
            checkBox := rowinfo->>'checkBox';
            dateBox := rowinfo->>'dateBox';
            richTextBox := rowinfo->>'richTextBox';
            dropDownList := rowinfo->>'dropDownList';
            foreignKey := rowinfo->>'foreignKey';
            dropDownTree := rowinfo->>'dropDownTree';
            numberBox := rowinfo->>'numberBox';
            numberSpinner := rowinfo->>'numberSpinner';
            timeSpinner := rowinfo->>'timeSpinner';
            dateTimeBox := rowinfo->>'dateTimeBox';
            sTamp := rowinfo->>'sTamp';
            -- parameter assignment

            return_error := language;
            return_eInfo := '';
            IF action ='add' Then
                CALL dbo.ab_test_control_Add(
                   sId ,
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
                   userId,
                   userName,
                   return_error,
                   return_eInfo);
	        ELSIF action = 'upp' Then
                CALL dbo.ab_test_control_Upp(
                   sId ,
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
                   userId,
                   sTamp,
                   return_error,
                   return_eInfo);
	        ELSIF action = 'del' Then
                CALL dbo.ab_test_control_Del(sId,userId,return_error, return_eInfo);
	        ELSE
                return_eInfo := concat('Marked[', action, '] undefined!');
	    	END IF;

            insert into OutInfo
                (action,sId,error,eInfo)
            values(rowinfo->>'action', sId, return_error, return_eInfo);
        END LOOP;

    info := json_agg(OutInfo)
                from (
                select * from OutInfo) as OutInfo;

    DROP TABLE OutInfo;
	error:='00000';
    eInfo:= 'successful completion';
    exception
        When Others Then
            get stacked diagnostics eInfo:= MESSAGE_TEXT,
                                    error:= RETURNED_SQLSTATE;
            eInfo:= concat('error in main procedure: ',eInfo);
END;
$$ LANGUAGE plpgsql;


-- text input and output
-- [
--     {
--         "action":"add",
--         "sId":"generated by uuid",
--         "textBox":"textbox1",
--         "checkBox":0,
--         "dateBox":"2020-11-12 04:17:43.635664",
--         "richTextBox":"richTextBox1",
--         "dropDownList":12,
--         "foreignKey":"foreignKey1",
--         "dropDownTree":12,
--         "numberBox":112.3,
--         "numberSpinner":12,
--         "timeSpinner":"timeSpinn",
--         "dateTimeBox":"2020-11-12 04:17:43.635664",
--         "sTamp":"2020-11-12 04:17:43.635664"
--     },
-- [
--     {
--         "sid": "1f9917eb-99b6-4a51-a9d3-30b3d4c84553",
--         "einfo": "successful add",
--         "error": "00000",
--         "action": "add"
--     }
-- ]
-- ]
-- test example
-- CALL dbo.ab_test_control_action(userId=>'120912', userName=> 'wangyifan', info=>'[
--     {
--         "action":"add",
--         "sId":"generated by uuid",
--         "textBox":"textbox2",
--         "checkBox":0,
--         "dateBox":"2020-11-12 04:17:43.635664",
--         "richTextBox":"richTextBox1",
--         "dropDownList":12,
--         "foreignKey":"foreignKey1",
--         "dropDownTree":12,
--         "numberBox":112.3,
--         "numberSpinner":12,
--         "timeSpinner":"timeSpinn",
--         "dateTimeBox":"2020-11-12 04:17:43.635664",
--         "sTamp":"2020-11-12 04:17:43.635664"
--     }]', entity=>'123', error=>'123', eInfo=>'123');

CALL dbo.ab_test_control_action(userId=>'120912', userName=> 'wangyifan', info=>'[
    {
        "action":"del",
        "sId":"1f9917eb-99b6-4a51-a9d3-30b3d4c84553",
        "textBox":"textbox2",
        "checkBox":0,
        "dateBox":"2020-11-12 04:17:43.635664",
        "richTextBox":"richTextBox1",
        "dropDownList":12,
        "foreignKey":"foreignKey1",
        "dropDownTree":12,
        "numberBox":112.3,
        "numberSpinner":12,
        "timeSpinner":"timeSpinn",
        "dateTimeBox":"2020-11-12 04:17:43.635664",
        "sTamp":"2020-11-12 04:17:43.635664"
    }]', entity=>'123', error=>'123', eInfo=>'123');

CREATE TABLE dbo.springTb
(
sId varchar(36) NOT NULL,
pId varchar(36) NULL,
tbType int NULL,
name varchar(50) NULL,
shortName varchar(50) NULL,
description varchar(256) NULL,
descriptionEn varchar(256) NULL,
tbName varchar(50) NULL,
fieldName varchar(50) NULL,
fieldNo int NULL,
isFile smallint NULL,
filePathNo varchar(36) NULL,
storedProcName varchar(256) NULL,
remark varchar NULL,
queue int NULL,
createUser varchar(36) NULL,
createTime timestamp with time zone default now(),
modifyUser varchar(36) NULL,
modifyTime timestamp with time zone default now(),
sTamp varchar NULL
)

COPY dbo.springtb 
FROM '/root/springtb.csv'
csv
HEADER
NULL 'NULL'

CREATE TABLE dbo.springField
(
    sId varchar(36) NOT NULL,
    tbId varchar(36) NULL,
    isField smallint NULL,
    name varchar(50) NULL,
    description varchar(256) NULL,
    descriptionEn varchar(256) NULL,
    fdType varchar(50) NULL,
    length bigint NULL,
    decimal bigint NULL,
    isNullable smallint NULL,
    isUseable smallint NULL,
    isForeignKey smallint NULL,
    fkTbId varchar(36) NULL,
    fkFieldId varchar(36) NULL,
    defaultValue varchar(500) NULL,
    uiType int NULL,
    uiMask varchar(100) NULL,
    uiVisible smallint NULL,
    uiReadOnly smallint NULL,
    uiWidth int NULL,
    uiDefault varchar(200) NULL,
    isAddField smallint NULL,
    isEditField smallint NULL,
    orderType int NULL,
    remark varchar NULL,
    queue int NULL,
    createUser varchar(36) NULL,
    createTime timestamp with time zone NULL,
    modifyUser varchar(36) NULL,
    modifyTime timestamp with time zone NULL,
    sTamp varchar NULL
)

CREATE or REPLACE PROCEDURE dbo.springTb_Del(
    INOUT _sId varchar(36),
    IN _modifyUser varchar,
    INOUT _error varchar,
    INOUT _eInfo varchar
)
AS $$

DECLARE 
    _procName varchar(50) := 'springTb_Del';    --存储过程名称
    _language varchar(50):= _error;    --语言代码
    _position bigint := 1;     --错误位置

    _count int;
    _pId varchar(36);
    _tabname varchar;
    _queue int;
	_tmp varchar;

BEGIN
    select count(*) into _count
    from dbo.springTb
    where pId=_sId;

    if _count>0 Then
        _error:='00000';
        _eInfo :='请先删除子项表。';
        return;
    END IF;

    select name, pId, queue into _tabname, _pId, _queue
    from dbo.springTb
    where sId = _sId;
    -- delete from springTranslation where tbName='springTb' and (sId=sId or path=('pId='+sId));
    -- delete from springTranslation where tbName='springField' and path=('tbId='+sId); 
    -- delete from springSp where tbId=sId;
    -- delete from dbo.springTbSpSetup where sId=sId;
    -- delete from dbo.springFdList_d where mId in (select sId
    --     from dbo.springFdList_m
    --     where tbId=sId);
    -- delete from dbo.springFdList_m where tbId=sId;
    -- delete from dbo.springFdForeignKey where tbId=sId;
    -- delete from dbo.springTbUiTemplate where tbId=sId;
    
    -- delete from dbo.springFileList where sId in (SELECT fileId
    --     FROM dbo.springFileTableRel
    --     where tbName like tabname)
    -- delete  FROM  dbo.springFileTableRel where tbName like tabname
	delete from dbo.springTb where sId=_sid RETURNING sId INTO _tmp;
--     EXECUTE 'delete from dbo.springTb where sId=$1 RETURNING *' INTO _tmp USING _sId;
    if _tmp is null THEN
    -- sid not exist
        _error:='00001';
        _eInfo:= 'sid not exist';
    ELSE
        if _pId is null Then
	        update dbo.springTb set queue=queue-1 where pId is null and queue>_queue;
        else
	    	update dbo.springTb set queue=queue-1 where pId=_pId and queue>_queue;
        END IF;
        _error:='00000';
        _eInfo:= 'successful delete: ' ||  _tmp;
    END IF;
    exception
        When Others Then
            rollback;
            get stacked diagnostics _eInfo:= MESSAGE_TEXT,
                                    _error:= RETURNED_SQLSTATE;
            _eInfo:= concat('error in delete procedure: ',_eInfo);
    COMMIT;
END;
$$ LANGUAGE plpgsql;


CREATE or REPLACE PROCEDURE dbo.springTb_Action(
    IN _userId varchar,      -- which user call the stored procedure
    IN _userName varchar,    -- user name
    INOUT _info jsonb,       -- input of action and details, output of result
    INOUT _entity varchar,   -- extra info
    INOUT _error varchar,    -- error code
	INOUT _eInfo varchar     -- error details
)
AS $$

DECLARE
	_procName varchar := 'springTb_Action';  --存储过程名称
    _language varchar := _error; --国家代码
    _position bigint := -1;		--错误位置
    _return_error varchar;
    _return_eInfo varchar;
  	_rowinfo jsonb;
    _action varchar;
    _sId varchar(36);
    _rowoutput jsonb;
    -- parameter list
    _pId varchar;
    _tbType smallint;
    _name varchar(50);
    _shortName varchar(50);
    _description varchar;
    _descriptionEn varchar;
    _tbName varchar(50);
    _fieldName varchar(50);
    _fieldNo int;
    _isFile smallint;
    _filePathNo varchar(36);
    _storedProcName varchar;
    _remark varchar;
    _sTamp timestamp with time zone;
    _queue int;
    -- parameter list

BEGIN
    --定义返回JSON临时表
    CREATE TEMP TABLE _OutInfo 
        (
        _action varchar(20),
        _sId varchar(36),
        _error varchar, 
        _eInfo varchar
        );
    FOR _rowinfo in SELECT * FROM jsonb_array_elements(_info)
        LOOP
            -- RAISE NOTICE '%',rowinfo;

            -- parameter assignment
            _action := _rowinfo->>'action';
            _sId := _rowinfo->>'sId';
            _pId := _rowinfo->>'pId';
            _tbType := _rowinfo->>'tbtype';
            _name := _rowinfo->>'name';
            _shortName := _rowinfo->>'shortName';
            _description := _rowinfo->>'description';
            _descriptionEn := _rowinfo->>'descriptionEn';
            _tbName := _rowinfo->>'tbName';
            _fieldName := _rowinfo->>'fieldName';
            _fieldNo := _rowinfo->>'fieldNo';
            _isFile := _rowinfo->>'isFile';
            _filePathNo := _rowinfo->>'filePathNo';
            _storedProcName := _rowinfo->>'storedProcName';
            _remark := _rowinfo->>'remark';
            _sTamp := _rowinfo->>'sTamp';
            _queue := _rowinfo->>'queue';
            -- parameter assignment

            _return_error := _language;
            _return_eInfo := '';
            IF _action ='add' Then

                -- CALL dbo.ab_test_control_Add(
                --    sId ,
                --    textBox,
                --    checkBox,
                --    dateBox,
                --    richTextBox,
                --    dropDownList,
                --    foreignKey,
                --    dropDownTree,
                --    numberBox,
                --    numberSpinner,
                --    timeSpinner,
                --    dateTimeBox,
                --    userId,
                --    userName,
                --    return_error,
                --    return_eInfo);
	        ELSIF _action = 'upp' Then
                -- CALL dbo.ab_test_control_Upp(
                --    sId ,
                --    textBox,
                --    checkBox,
                --    dateBox,
                --    richTextBox,
                --    dropDownList,
                --    foreignKey,
                --    dropDownTree,
                --    numberBox,
                --    numberSpinner,
                --    timeSpinner,
                --    dateTimeBox,
                --    userId,
                --    sTamp,
                --    return_error,
                --    return_eInfo);
	        ELSIF _action = 'del' Then
                CALL dbo.springTb_Del(_sId,_userId,_return_error, _return_eInfo);
	        ELSIF _action = 'move' Then
	        ELSIF _action = 'paste' Then
            ELSIF _action = 'getmoudel' Then
            ELSIF _action = 'setmoudel' Then
            ELSE
                _return_eInfo := concat('Marked[', _action, '] undefined!');
	    	END IF;

            insert into _OutInfo
                (_action,_sId,_error,_eInfo)
            values(_action, _sId, _return_error, _return_eInfo);
        END LOOP;

    _info := json_agg(_OutInfo)
                from (
                select * from _OutInfo) as _OutInfo;

    DROP TABLE _OutInfo;
	_error:='00000';
    _eInfo:= 'Execution Complete';
    exception
        When Others Then
            get stacked diagnostics _eInfo:= MESSAGE_TEXT,
                                    _error:= RETURNED_SQLSTATE;
            _eInfo:= concat('error in main procedure: ',_eInfo);
END;
$$ LANGUAGE plpgsql;

CALL dbo.springTb_Action(_userId=>'120912', _userName=> 'wangyifan', _info=>'[
    {
        "action":"del",
        "sId":"123",
        "pId":"textbox2",
        "tbType": 0,
		"name": "testname",
		"shortName": "testshortName",
		"description": "testdescription",
		"descriptionEn": "testdescriptionEn",
		"tbName": "testtbName",
		"fieldName": "testfieldName",
        "fieldNo" : 123,
		"isFile": 0,
        "filePathNo" : "testfilePathNo",
		"storedProcName": "teststoredProcName",
		"remark": "testremark",
		"sTamp": "2020-11-12 04:17:43.635664",
        "queue":1
    }]', _entity=>'123', _error=>'123', _eInfo=>'123');

select column_name
from information_schema.columns
where table_schema='dbo' and table_name='springtb'


CREATE TABLE dbo.springTbTypeRel
(
    sId varchar(36) NOT NULL,
    tbId  varchar(36) NULL,
    pNo bigint NULL,
    cNo bigint NULL,
    name  varchar(50) NULL,
    description varchar NULL,
    descriptionEn varchar NULL,
    Remark varchar NULL,
    queue bigint NULL,
    createUser varchar(36) NULL,
    createTime timestamp with time zone NULL,
    modifyUser varchar(36) NULL,
    modifyTime timestamp with time zone NULL,
    sTamp varchar NULL
)

COPY dbo.springtbtyperel 
FROM '/postgresql/springTbTypeRel.csv'
csv
HEADER
NULL 'NULL';

CREATE TABLE dbo.springDbInfo(
	sId varchar(36) NOT NULL,
	sysDB smallint NULL,
	name varchar(50) NULL,
	description varchar NULL,
	descriptionEn varchar NULL,
	Version varchar NULL,
	isEdit smallint NULL
);

COPY dbo.springDbInfo
FROM '/postgresql/springDbInfo.csv'
csv
HEADER
NULL 'NULL';

CREATE TABLE dbo.springSpTranslation(
	sId varchar(36) NOT NULL,
	spId varchar(36) NULL,
	language bigint NULL,
	position bigint NULL,
	description varchar NULL,
	descriptionEn varchar NULL,
	errInfo1 varchar NULL,
	errAdd1 varchar NULL,
	errInfo2 varchar NULL,
	errAdd2 varchar NULL,
	errInfo3 varchar NULL,
	errAdd3 varchar NULL,
	errInfo4 varchar NULL,
	errAdd4 varchar NULL,
	errInfo5 varchar NULL,
	errAdd5 varchar NULL,
	queue int NULL,
    createUser varchar(36) NULL,
    createTime timestamp with time zone NULL,
    modifyUser varchar(36) NULL,
    modifyTime timestamp with time zone NULL,
    sTamp varchar NULL
);

COPY dbo.springSpTranslation
FROM '/postgresql/springSpTranslation.csv'
csv
HEADER
NULL 'NULL';

CREATE TABLE dbo.springSp
(
    sId varchar(36) NOT NULL,
    tbId varchar(36) NOT NULL,
    name varchar(50) NOT NULL,
    description varchar NULL,
    descriptionEn varchar NULL,
    type int NULL,
    remark varchar NULL,
    queue int NULL,
    createUser varchar(36) NULL,
    createTime timestamp with time zone NULL,
    modifyUser varchar(36) NULL,
    modifyTime timestamp with time zone NULL,
    sTamp varchar NULL
);

COPY dbo.springSp
FROM '/postgresql/springSp.csv'
csv
HEADER
NULL 'NULL';

CREATE or REPLACE PROCEDURE dbo.springTb_Upp(
    INOUT _sId varchar(36),
    IN _pId varchar(36),
    IN _tbType int,
	IN _name varchar(50),
	IN _shortName varchar(50),
	IN _description varchar,
	IN _descriptionEn varchar,
	IN _tbName varchar(50),
	IN _fieldName varchar(50),
	IN _fieldNo int,
	IN _isFile smallint,
	IN _filePathNo varchar(36),
	IN _storedProcName varchar,
	IN _remark varchar,
	IN _modifyUser varchar,
    INOUT _error varchar,
    INOUT _eInfo varchar
)
AS $$

DECLARE 
    _procName varchar(50) := 'springTb_Upp';    --存储过程名称
    _language varchar(50):= _error;    --语言代码
    _position bigint := 1;     --错误位置

    _ctbType int;

    _count int;
    _pId varchar(36);
    _tabname varchar;
    _queue int;
	_tmp varchar;

BEGIN
	--判断与父项的连接是否允许----------
    CALL dbo.SpringCheckRel2('springTb', 'tbType', _pId, _tbType, _eInfo);
    if _eInfo != '0' THEN
		return;
	end if;
	-------------------------------------
	--判断与子项的连接是否允许-----------
    for _ctbType in select tbType from dbo.springTb where pId=_sId
    loop
    	CALL dbo.SpringCheckRel('springTb', 'tbType', _tbType, _ctbType, _eInfo);
		if _eInfo != '0' Then
			return;
		end if;
		_error = _language;
    END LOOP;
	------------------------------------

	--表名默认与名称相同
	if _tbType=1 and _tbName is null Then
	    _tbName:=_name;
    end if;
	if _tbType=1 and _storedProcName is null Then
	_storedProcName:=_tbName || '_Action';
    end if;

    _error := '';
	if _name='' or _name is null Then  -- 名称不能为空...
		_position = 1;
		_error:=dbo.SpringSpTranslation_Error(_procName,_language,_position,'','','','','');
		return;
	end if;

	if _tbType=1 Then-- 名称已经存在
		if exists (select *
		from SpringTb
		where sId!=@sId and tbType=1 and name=_name) Then
			_position := 2;
			if _error='' Then
					_error:=dbo.SpringSpTranslation_Error(_procName,_language,_position,_name,'','','','');
			    else
			    	_error:=_error || chr(10) || dbo.SpringSpTranslation_Error(_procName,_language,_position,_name,'','','','');
			end if;
		end if;
	end if;

	if _error!='' Then
	return;
    end if;

    Update springTb set
			tbType=_tbType,
			name=_name,
			shortName=_shortName,
			description=_description,
			descriptionEn=_descriptionEn,
			tbName=_tbName,
			fieldName=_fieldName,
			fieldNo=_fieldNo,
			isFile=_isFile,
			filePathNo=_filePathNo,
			storedProcName=_storedProcName,
			remark=_remark,
			modifyUser=_modifyUser,
			modifyTime=now()
         where sId=_sId;

    _error:='00000';
    _eInfo:= 'successful update';

    exception
        When Others Then
            rollback;
            get stacked diagnostics _eInfo:= MESSAGE_TEXT,
                                    _error:= RETURNED_SQLSTATE;
            _eInfo:= concat('error in delete procedure: ',_eInfo);
    COMMIT;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION dbo.SpringSpTranslation_Error
(
	_procName varchar(50),
    _language varchar(50),
    _position bigint,
    _errAdd1 varchar,
	_errAdd2 varchar,
	_errAdd3 varchar,
	_errAdd4 varchar,
	_errAdd5 varchar
)
RETURNS varchar as $_Return$
	-- 取得语言编码
	DECLARE _errInfo1 varchar;
			_errInfo2 varchar;
			_errInfo3 varchar;
			_errInfo4 varchar;
			_errInfo5 varchar;
            _Return varchar;
            _isEdit smallint;
			_languageCode varchar(50);
BEGIN
    if _language ='' Then
		_language:=null;
	end if;
	if _errAdd1 is null Then
	    _errAdd1:='';
    end if;
	if _errAdd2 is null Then
	    _errAdd2:='';
	end if;
    if _errAdd3 is null Then
	    _errAdd3:='';
	end if;
    if _errAdd4 is null Then
	    _errAdd4:='';
	end if;
    if _errAdd5 is null Then
	    _errAdd5:='';
    end if;

    select isEdit into _isEdit from dbo.springDbInfo;
    if  _isEdit is null Then
        _isEdit:=0;
    end if;

    if _language is null Then
		select  errInfo1, errInfo2, errInfo3, errInfo4, errInfo5 into _errInfo1, _errInfo2, _errInfo3, _errInfo4, _errInfo5
			from    dbo.springSpTranslation as sptrn 
				inner join dbo.SpringSp as sp on sptrn.spId=sp.sId
			where  sp.name=_procName and sptrn.language is null and sptrn.Position = _position;
    else
		select  errInfo1, errInfo2, errInfo3, errInfo4, errInfo5 into _errInfo1, _errInfo2, _errInfo3, _errInfo4, _errInfo5
			from    dbo.springSpTranslation as sptrn 
				inner join dbo.SpringSp as sp on sptrn.spId=sp.sId
			where  sp.name=_procName and sptrn.language = _language and sptrn.Position = _position;
    end if;
    if _errInfo1 is null and _errInfo2 is null and _errInfo3 is null and _errInfo4 is null and _errInfo5 is null Then
		    if _language is null Then
				_language:='默认';
            end if;
			return 'Stored procedure[' || _procName || ']:language[' || _language+',]position['  || _position  || '],Undefined Translation!';	
    end if;
        
        
	if _errInfo1 is null Then
		_errInfo1 := '';
    end if;
	if _errInfo2 is null Then
		_errInfo2 := '';
    end if;
	if _errInfo3 is null Then
		_errInfo3 := '';
	end if;
    if _errInfo4 is null Then
		_errInfo4 := '';
	end if;
    if _errInfo5 is null Then
		_errInfo5 := '';
    end if;
   if _isEdit=1 Then
	    _Return := 'Stored procedure[' || _procName || ']:' || _errInfo1 || _errAdd1 || _errInfo2 || _errAdd2 || _errInfo3 || _errAdd3 || _errInfo4 || _errAdd4 || _errInfo5 || _errAdd5;
   else	 
       _Return = _errInfo1 || _errAdd1 || _errInfo2 || _errAdd2 || _errInfo3 || _errAdd3 || _errInfo4 || _errAdd4 || _errInfo5 || _errAdd5;  
	end if;
   return _Return;
END;
$_Return$ LANGUAGE plpgsql;



CALL dbo.springTb_Upp(
    _sid => '378ea5cb-0916-4cbc-a10c-8742d36e3d1c', 
    _pid => 'f0eff541-4e35-4ef5-a5ae-7df2df3f05ea', 
    _tbtype => 1, 
    _name => 'springTb', 
    _shortname => '123', 
    _description => '表测试', 
    _descriptionen => '123', 
    _tbname => 'springTb', 
    _fieldname => '123', 
    _fieldno => 1, 
    _isfile => 0, 
    _filepathno => '123', 
    _storedprocname => 'springTb_Action', 
    _remark => '123', 
    _modifyuser => '123', 
    _error => '123', 
    _einfo => '123'
);

CALL dbo.SpringCheckRel2(
    _editTbName => 'springTb', 
    _typeName => 'tbType', 
    _pId => 'f0eff541-4e35-4ef5-a5ae-7df2df3f05ea', 
    _cType => 1, 
    _error => '123'
);

CALL dbo.SpringCheckRel(
    _editTbName => 'springTb', 
    _typeName => 'tbType', 
    _pType => 1, 
    _cType => 1, 
    _error => '123'
);

CALL dbo.SpringSpTranslation_Error(
    _procName => 'springTb_Action', 
    _language => '0000', 
    _position => 1
);


CALL dbo.springTb_Action(_userId=>'120912',
 _userName=> 'wangyifan',
  _info=>'[{"action":"upp",
  "sId":"378ea5cb-0916-4cbc-a10c-8742d36e3d1c",
  "pId":"f0eff541-4e35-4ef5-a5ae-7df2df3f05ea",
  "tbType":1,
  "name":"springTb",
  "shortName":"123",
  "description":"表测试",
  "descriptionEn":"123",
  "tbName":"springTb",
  "fieldName":"123",
  "fieldNo":1,
  "isFile":0,
  "filePathNo":"123",
  "storedProcName":"springTb_Action",
  "remark":"123"}]',
  _entity=>'123',
  _error=>'123',
  _eInfo=>'123'
);


CALL dbo.springTb_Upp(
    _sid => '378ea5cb-0916-4cbc-a10c-8742d36e3d1c', 
    _pid => 'f0eff541-4e35-4ef5-a5ae-7df2df3f05ea', 
    _tbtype => 1, 
    _name => 'springTb', 
    _shortname => '123', 
    _description => '表测试', 
    _descriptionen => '123', 
    _tbname => 'springTb', 
    _fieldname => '123', 
    _fieldno => 1, 
    _isfile => 0, 
    _filepathno => '123', 
    _storedprocname => 'springTb_Action', 
    _remark => '123', 
    _modifyuser => '123', 
    _error => '123', 
    _einfo => '123'
);

CALL dbo.springTb_Upp(
    '378ea5cb-0916-4cbc-a10c-8742d36e3d1c', 
    'f0eff541-4e35-4ef5-a5ae-7df2df3f05ea', 
    1, 
    'springTb', 
    '123', 
    '表测试', 
    '123', 
    'springTb', 
    '123', 
    1, 
    0, 
    '123', 
    'springTb_Action', 
    '123', 
    '123', 
    '123', 
    '123'
);