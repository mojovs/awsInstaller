#include "CmdProc.h"
#include <QDebug>
#include <QRegExp>
#include <QDir>
#define CMD ""
#define POWERSHELL ("powershell")
#define DISM ("dism")
#define ADB ("adb-tools/adb.exe")
/*------ 构造 ------*/
CmdProc::CmdProc(QObject *parent) : QProcess(parent)
{
    initSignals();
}

/*------ 执行命令------*/
void CmdProc::execute(const QString &progPath, const QStringList &args)
{
    QStringList adbArgs;
    adbArgs << args;
    qDebug() << adbArgs.join(" ");
    start(progPath, adbArgs);
}

/*------ 列出系统所有的功能------*/
void CmdProc::listFunction()
{
    QStringList args;
    args << "Get-WindowsOptionalFeature"
         << "-Online";
    execute(POWERSHELL, args);
}

void CmdProc::enableFunction(const QString &funcName) {}

/*------ 一键开启所有hyper功能和virtual------*/
/*  需要打开下面功能
 *  VirtualMachinePlatform                      Enabled
    Microsoft-Hyper-V-All                       Enabled
    Microsoft-Hyper-V                           Enabled
    Microsoft-Hyper-V-Tools-All                 Enabled
    Microsoft-Hyper-V-Management-PowerShell     Enabled
    Microsoft-Hyper-V-Hypervisor                Enabled
    Microsoft-Hyper-V-Services                  Enabled
    Microsoft-Hyper-V-Management-Clients
*/
void CmdProc::enHyperAllInOne()
{
    QStringList args;
    args << "-online"
         << "-Enable-Feature"
         << "-FeatureName:VirtualMachinePlatform"
         << "-FeatureName:Microsoft-Hyper-V-All"
         << "-FeatureName:Microsoft-Hyper-V"
         << "-FeatureName:Microsoft-Hyper-V-Tools-All"
         << "-FeatureName:Microsoft-Hyper-V-Management-PowerShell"
         << "-FeatureName:Microsoft-Hyper-V-Hypervisor"
         << "-FeatureName:Microsoft-Hyper-V-Services"
         << "-FeatureName:Microsoft-Hyper-V-Management-Clients"
         << "-NoRestart";

    execute(DISM, args);
    waitForFinished();
}
/*------ 关闭所有hyper相关功能------*/
void CmdProc::disHyperAllInOne()
{
    QStringList args;
    args << "-online"
         << "-Disable-Feature"
         << "-FeatureName:VirtualMachinePlatform"
         << "-FeatureName:Microsoft-Hyper-V-All"
         << "-FeatureName:Microsoft-Hyper-V"
         << "-FeatureName:Microsoft-Hyper-V-Tools-All"
         << "-FeatureName:Microsoft-Hyper-V-Management-PowerShell"
         << "-FeatureName:Microsoft-Hyper-V-Hypervisor"
         << "-FeatureName:Microsoft-Hyper-V-Services"
         << "-FeatureName:Microsoft-Hyper-V-Management-Clients"
         << "-NoRestart";

    execute(DISM, args);
    waitForFinished();
}

void CmdProc::disableFunction(const QString &funcName) {}

void CmdProc::installSubSystem(const QString &path)
{
    QStringList args;
    args << "Add-AppxPackage"
         << "-path" << path;
    execute(POWERSHELL, args);
    //等待安装完成
}

void CmdProc::adbConnectSubSystem(const QString &ip)
{
    QStringList args;
    args << "connect" << ip;
    execute(ADB, args);
}

void CmdProc::adbInstallApk(const QString &apkPath)
{
    QStringList args;
    args << "install" << apkPath;
    execute(ADB, args);
}

QSharedPointer<QMap<QString, bool>> &CmdProc::getFuncList()
{
    listFunction();
    waitForFinished();
    //创建一个智能指针
    ptr = QSharedPointer<QMap<QString, bool>>(new QMap<QString, bool>);
    //获取所有输出
    //正则解析出键值对
    QString regStr = "FeatureName[ :]+([a-zA-Z\\-0-9]*)\\r\\nState\\s*:\\s(\\w*)";
    QRegExp reg(regStr); //开始匹配
    QString key;
    QString isEnable;
    int pos = 0;
    while ((pos = reg.indexIn(m_stdOutput, pos)) != -1)
    {
        key      = reg.cap(1);
        isEnable = reg.cap(2);
        pos += reg.matchedLength(); //位置递进

        bool value = false;
        if (isEnable == "Disabled")
        {
            value = false;
        }
        else if (isEnable == "Enabled")
        {
            value = true;
        }
        else
        {
            qDebug() << "RegExp failed";
        }

        ptr->insert(key, value); //添加到表中
    }
    return ptr;
}

const QString &CmdProc::stdOutput() const
{
    return m_stdOutput;
}

void CmdProc::setStdOutput(const QString &newStdOutput)
{
    m_stdOutput = newStdOutput;
}

/*------ 绑定所有信号------*/
void CmdProc::initSignals()
{
    //执行错误
    connect(this, &QProcess::errorOccurred, this,
            [this](QProcess::ProcessError error)
            {
                if (QProcess::FailedToStart == error)
                {
                    emit cmdProcessResult(CMD_ERROR_MISSING_BINARY);
                }
                else
                {
                    emit cmdProcessResult(CMD_ERROR_START);
                }
                qDebug() << error;
            });
    //执行完成
    connect(this, static_cast<void (QProcess::*)(int, QProcess::ExitStatus)>(&QProcess::finished), this,
            [this](int exitCode, QProcess::ExitStatus exitStatus)
            {
                if (QProcess::NormalExit == exitStatus && 0 == exitCode)
                {
                    emit cmdProcessResult(CMD_SUCCESS_EXEC);
                }
                else
                {
                    emit cmdProcessResult(CMD_ERROR_EXEC);
                }
                qDebug() << exitCode << exitStatus;
            });

    //读取错误
    connect(this, &QProcess::readyReadStandardError, this,
            [this]()
            {
                m_errOutput = QString::fromLocal8Bit(readAllStandardError()).trimmed();
                qDebug() << m_errOutput;
            });
    //读取输出
    connect(this, &QProcess::readyReadStandardOutput, this,
            [this]()
            {
                m_stdOutput = QString::fromLocal8Bit(readAllStandardOutput()).trimmed();
                qDebug() << m_stdOutput;
            });
    //线程开始
    connect(this, &QProcess::started, this, [this]() { emit cmdProcessResult(CMD_SUCCESS_START); });
}
