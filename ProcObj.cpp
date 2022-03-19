#include "ProcObj.h"
#include <QDebug>
#include <QMap>
#include <QDir>

/*----- 构造 -----*/
ProcObj::ProcObj(QObject *parent) : QObject(parent)
{
    proc = new CmdProc();
    //绑定信号
    connect(proc, SIGNAL(CmdProc::cmdProcessResult(CmdProc::CMD_EXEC_RESULT)), this,
            SLOT(on_cmdProcessResult(CmdProc::CMD_EXEC_RESULT)));
    //设置默认路径为程序当前路径
    if (m_path.isEmpty())
    {
        m_path = QDir::currentPath() + "/aws.Msixbundle";
    }
}

/*----- 析构 -----*/
ProcObj::~ProcObj()
{
    delete proc;
}

/*----- 安装子系统-----*/
void ProcObj::installSubSystem()
{
    proc->installSubSystem(m_path);
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

void ProcObj::on_cmdProcessResult(CmdProc::CMD_EXEC_RESULT res)
{
    if (res != CmdProc::CMD_SUCCESS_EXEC)
    {
        emit exeFailed();
        qDebug() << "cmd failed, result is " << res;
        qDebug() << "cmd args is  " << proc->program() << proc->arguments();
    }
        qDebug() << "cmd success, result is " << res;
    emit exeSuccess(); //发送执行成功命令
}

/*----- 槽：逐行读取-----*/
