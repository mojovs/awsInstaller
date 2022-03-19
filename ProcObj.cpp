#include "ProcObj.h"
#include <QDebug>
#include <QMap>
#include <QDir>
#include <QThread>
#pragma execution_character_set("utf-8")
/*----- 构造 -----*/
ProcObj::ProcObj(QObject *parent) : QObject(parent)
{
    proc = new CmdProc();
    //绑定信号
    // connect(proc, SIGNAL(cmdProcessResult()), this, SLOT(on_cmdProcessResult(CmdProc::CMD_EXEC_RESULT)));
    connect(proc, &CmdProc::cmdProcessResult, this, &ProcObj::on_cmdProcessResult);
}

/*----- 析构 -----*/
ProcObj::~ProcObj()
{
    delete proc;
}

/*----- 安装子系统-----*/
void ProcObj::installSubSystem()
{
    //设置默认路径为程序当前路径
    if (m_path.isEmpty())
    {
        m_path = QDir::currentPath() + "/aws.Msixbundle";
    }

    proc->installSubSystem(m_path);
    emit adbSubSysInstallS();
}

/*----- 开启hyper功能-----*/
void ProcObj::enHyper()
{
    proc->enHyperAllInOne();
}

/*-----关闭hyper功能-----*/
void ProcObj::disHyper()
{
    proc->disHyperAllInOne();
}

/*-----adb连接到subsystem-----*/
void ProcObj::adbConnect()
{
    //尝试连接三次
    for (int i = 0; i < 3; i++)
    {
        proc->adbConnectSubSystem(m_subIP);
        proc->waitForFinished();
        QString data = proc->stdOutput();
        //连接成功
        if (data.contains("already"))
        {
            qDebug() << "adb connect success";
            emit adbConnectSuccess();
            break; //一但发现连接成功就中断
        }
        else
        {
            qDebug() << "adb connect failed";
            emit adbConnectFailed();
        }
        QThread::msleep(500);
    }
}

const QString &ProcObj::path() const
{
    return m_path;
}

void ProcObj::setPath(const QString &newPath)
{
    if (m_path == newPath) return;
    m_path = newPath;
    emit pathChanged();
}

const QString &ProcObj::subIP() const
{
    return m_subIP;
}

void ProcObj::setSubIP(const QString &newSubIP)
{
    if (m_subIP == newSubIP) return;
    m_subIP = newSubIP;
    emit subIPChanged();
}

void ProcObj::on_cmdProcessResult(CmdProc::CMD_EXEC_RESULT res)
{
    if (res == CmdProc::CMD_ERROR_EXEC || res == CmdProc::CMD_ERROR_START || res == CmdProc::CMD_ERROR_MISSING_BINARY)
    {
        emit exeFailed();
        qDebug() << "cmd failed, result is " << res;
        qDebug() << "cmd args is  " << proc->program() << proc->arguments();
    }
    else if (res == CmdProc::CMD_SUCCESS_EXEC)
    {
        qDebug() << "cmd success, result is " << res;
        emit exeSuccess(); //发送执行成功命令
    }
}

void ProcObj::adbInstallApk()
{
    proc->adbInstallApk(m_apkPath);
    proc->waitForFinished();
    QString data = proc->stdOutput();
    //如果安装成功
    if (data.contains("Success"))
    {
        emit adbApkInstallS();
    }
    else
    {
        emit adbApkInstallF();
    }
}

const QString &ProcObj::apkPath() const
{
    return m_apkPath;
}

void ProcObj::setApkPath(const QString &newApkPath)
{
    if (m_apkPath == newApkPath) return;
    m_apkPath = newApkPath;
    emit apkPathChanged();
}
