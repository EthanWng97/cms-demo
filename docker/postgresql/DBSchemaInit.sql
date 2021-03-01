-- DBSchemaInit.sql
CREATE SCHEMA dbo;

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
);

COPY dbo.springtb 
FROM '/postgresql/springTb.csv'
csv
HEADER
NULL 'NULL';

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
    modifyTime timestamp with time zone NULL
);


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
    createTime timestamp
    with time zone NULL,
    modifyUser varchar
    (36) NULL,
    modifyTime timestamp
    with time zone NULL,
    sTamp varchar NULL
);

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