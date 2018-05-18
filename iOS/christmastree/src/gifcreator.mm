#import <Foundation/Foundation.h>

#include <QtCore/QDir>
#include <QtGui/QImage>

#include "gif.h"
#include "gifcreator.h"

GIFCreator::GIFCreator(QObject *parent) : QObject(parent)
{
}

GIFCreator::~GIFCreator()
{
}

QString GIFCreator::imageFilePathMask() const
{
    return QDir(QString::fromNSString(NSTemporaryDirectory())).filePath("image_%1.jpg");
}

QString GIFCreator::gifFilePath() const
{
    return QDir(QString::fromNSString(NSTemporaryDirectory())).filePath("image.gif");
}

bool GIFCreator::createGIF(int frames_count, int frame_delay)
{
    QImage first_image(imageFilePathMask().arg(0));

    if (!first_image.isNull()) {
        GifWriter gif_writer;

        if (GifBegin(&gif_writer, gifFilePath().toUtf8(), first_image.width(), first_image.height(), frame_delay)) {
            for (int frame = 0; frame < frames_count; frame++) {
                QImage image(imageFilePathMask().arg(frame));

                if (!image.isNull()) {
                    if (!GifWriteFrame(&gif_writer,
                                       image.convertToFormat(QImage::Format_Indexed8).
                                             convertToFormat(QImage::Format_RGBA8888).constBits(),
                                       image.width(), image.height(), frame_delay)) {
                        GifEnd(&gif_writer);

                        return false;
                    }
                } else {
                    GifEnd(&gif_writer);

                    return false;
                }
            }

            return GifEnd(&gif_writer);
        } else {
            return false;
        }
    } else {
        return false;
    }
}
