#include "FuncModel.h"
#include <QDebug>
/*------ 可选功能 ------*/
FuncModel::FuncModel(QObject *parent) : QAbstractListModel(parent)
{
    //创建prcess
    proc = new CmdProc();
    //运行命令
    proc->getFuncList();
    //获取图
    m_map = proc->getFuncList().data(); //获取map
    qDebug() << "getMap";
    //添加到model里面
    QMap<QString, bool>::Iterator iterator = m_map->begin();
    //清除变量
    nameList.clear();
    enList.clear();
    qDebug() << "QMap size:" << m_map->size();
    //设置模型列表里的内容
    beginResetModel();
    while (iterator != m_map->end())
    {
        //导入列表
        nameList.append(iterator.key());
        enList.append(iterator.value());
        //迭代递进
        iterator++;
    }
    endResetModel();
}

FuncModel::~FuncModel()
{
    delete proc;
}

void FuncModel::listAllFunc() {}
/*------ 检查是否已经开启了该功能 ------*/
/*  需要打开下面功能
 *  VirtualMachinePlatform
    Microsoft-Hyper-V-All
    Microsoft-Hyper-V
    Microsoft-Hyper-V-Tools-All
    Microsoft-Hyper-V-Management-PowerShell
    Microsoft-Hyper-V-Hypervisor
    Microsoft-Hyper-V-Services
    Microsoft-Hyper-V-Management-Clients
*/
void FuncModel::isFunctionAllReady()
{
    //检查
    QStringList names;
    names << "VirtualMachinePlatform"
          << "Microsoft-Hyper-V-All"
          << "Microsoft-Hyper-V"
          << "Microsoft-Hyper-V-Tools-All"
          << "Microsoft-Hyper-V-Management-PowerShell"
          << "Microsoft-Hyper-V-Hypervisor"
          << "Microsoft-Hyper-V-Services"
          << "Microsoft-Hyper-V-Management-Clients";
    //循环匹配
    for (int i = 0; i < names.length(); i++)
    {
        int index = nameList.indexOf(names.at(i));
        //但凡有一个没开的
        if (enList.at(index) == false)
        {
            qDebug() << "dont enable the functions!!";
            emit funcsAllReady(false);
        }
    }
    //发送成功信号
    emit funcsAllReady(true);
}

QVariant FuncModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid()) return QVariant();
    if (index.row() >= nameList.size()) return QVariant();
    //开始返回有用的数据
    if (role == RoleName)
        return nameList.at(index.row());
    else if (role == RoleEnable)
        return enList.at(index.row());
    else
        return QVariant();
}

bool FuncModel::insertRows(int row, int count, const QModelIndex &parent)
{
    return true;
}
/*------设置data ------*/
bool FuncModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (index.isValid())
    {
        if (role == RoleName)
        {
            nameList.replace(index.row(), value.toString());
            return true;
        }
        else if (role == RoleEnable)
        {
            enList.replace(index.row(), value.toBool());
            return true;
        }
        else
        {
            return false;
        }
    }
    return false;
}
/*------ 行数 ------*/
int FuncModel::rowCount(const QModelIndex &parent) const
{
    return nameList.size();
}

QHash<int, QByteArray> FuncModel::roleNames() const
{
    QHash<int, QByteArray> names;
    names[RoleName]   = "FuncName";
    names[RoleEnable] = "FuncEnable";
    return names;
}
