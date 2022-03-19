#include "DownloadObj.h"
#include <QDir>
#include <QDebug>
#define MB (1024 * 1024)

/*----- 构造 -----*/
DownloadObj::DownloadObj(QObject *parent) : QObject{parent}
{
    m_urlStr =
        "http://tlu.dl.delivery.mp.microsoft.com/filestreamingservice/files/d81456bd-ee18-43b1-8257-626d01eb2409?P1=1647723330&P2=404&P3=2&P4=NhJ%2fHFmps76NkssFpdD2fJT8t19Y%2fIn6WIlLmkpUtT78matNSiEHIX%2bslh9%2b%2fKVJB%2bRI%2bkzwxo%2flL4PeWDRg%2bw%3d%3d";
}

/*----- 析构 -----*/
DownloadObj::~DownloadObj()
{
    delete m_file;
}
/*----- 开始执行网络下载 -----*/
void DownloadObj::start()
{
    QString filePath = QDir::currentPath() + "/aws.Msixbundle";
    m_file           = new QFile(filePath);
    //打开文件
    if (!m_file->open(QIODevice::WriteOnly))
    {
        emit("Open file erro");
        qDebug() << "Open file erro";
        return;
    }
    //初始化url
    QUrl urlSpec = QUrl::fromUserInput(m_urlStr);
    if ((!urlSpec.isValid()) || m_urlStr.isEmpty())
    {
        emit("url erro");
        return;
    }
    //发送一个下载请求
    m_reply = m_netmanager.get(QNetworkRequest(urlSpec));
    //等待回复
    connect(m_reply, SIGNAL(readyRead()), this, SLOT(on_readyRead()));
    connect(m_reply, SIGNAL(downloadProgress(qint64, qint64)), this, SLOT(on_downloadProgress(qint64, qint64)));
    //开始计时
    m_downloadTimer.start();
}
/*----- urlStr qml属性 -----*/
const QString &DownloadObj::getUrlStr() const
{
    return m_urlStr;
}

void DownloadObj::setUrlStr(const QString &newUrlStr)
{
    if (m_urlStr == newUrlStr) return;
    m_urlStr = newUrlStr;
    emit urlStrChanged();
}

void DownloadObj::resetUrlStr()
{
    setUrlStr({}); // TODO: Adapt to use your actual default value
}
/*----- 槽 开始读取网络内容 -----*/
void DownloadObj::on_readyRead()
{
    //创建一个文件
    m_file->write(m_reply->readAll());
}

/*----- 槽 下载进度-----*/
void DownloadObj::on_downloadProgress(qint64 bytesRecved, qint64 bytesTotal)
{
    //获取上次时间包差值
    qint64 dBytes = (bytesRecved - prevBytes) / MB;
    qreal dTime   = (m_downloadTimer.elapsed() - preTime) / 1000;
    if (dTime != 0 || dBytes != 0)
    {
        m_speed = dBytes / dTime;
    }
    //计算下载速度
    //发送信号
    emit downloadProgress(bytesRecved, bytesTotal, m_speed);
    //存储该次下载包信息
    prevBytes = bytesRecved;
    preTime   = m_downloadTimer.elapsed();
}

/*----- 槽 下载完成-----*/
void DownloadObj::on_finished()
{
    //关闭连接
    m_netmanager.deleteLater();
    m_reply->deleteLater();
    //关闭文件
    m_file->close();
    emit downloadFinished();
}

/*----- 槽 下载发生错误-----*/
void DownloadObj::on_errorOccurred(QNetworkReply::NetworkError code)
{
    //关闭连接
    m_netmanager.deleteLater();
    m_reply->deleteLater();
    //关闭文件
    m_file->close();
    emit downloadError();
}
