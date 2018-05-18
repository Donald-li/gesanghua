function initWebuploader(el, config, image_count) {
  // debugger
  if (!config) {
    config = {}
  }
  config = $.extend({
    thumbnailWidth: 300, //缩略图宽度
    thumbnailHeight: 300, //缩略图高度
    showDestroy: true, //是否显示删除链接
    showStatus: true, //是否显示状态信息
    showProgress: true, //是否显示进度条
    uploaderConfig: {} //上传文件参数
  }, config)

  var webuploader = $(el);
  var list = webuploader.find('.upload-list');
  var picker = webuploader.find('.upload-pick');
  var thumbnailHeight = config.thumbnailHeight;
  var thumbnailWidth = config.thumbnailWidth;

  var uploader = WebUploader.create($.extend(config.uploaderConfig, {
      auto: true,
      swf: '/assets/webuploader/Uploader.swf',
      server: webuploader.attr('data-url'),
      resize: false,
      afterUpload: undefined,
      compress: {
        // 图片质量，只有type为`image/jpeg`的时候才有效。
        quality: 100,
        compressSize: 10000000
      },
      fileNumLimit: image_count,
      fileSingleSizeLimit: 1024 * 1024 * 10,
      formData: {
        asset_type: webuploader.attr('data-type')
      }
    }
    )
  );

  //csrf_token
  uploader.on('uploadBeforeSend', function (obj, data, headers) {
    headers['X-CSRF-Token'] = $("meta[name=csrf-token]").attr('content');
    ;
  });

  //选择文件
  uploader.on('fileQueued', function (file) {
    if (config.uploadType === 'image') {
      //删除已有图片
      if (!uploader.options.pick.multiple) {
        list.find('li.file-item').remove();
      }
      var partial = '<li id="' + file.id + '" class="file-item thumbnail">' + '<img/>';
      if (config.showStatus) {
        partial += '<p class="state">等待上传</p>'
      }
      partial += '</li>';
      list.prepend(partial);
      var img = list.find('#' + file.id + ' img');

      uploader.makeThumb(file, function (error, src) {
        if (error) {
          img.replaceWith('<span>不能预览</span>');
          return;
        }
        img.attr('src', src);
      }, thumbnailWidth, thumbnailHeight);

    } else if (config.uploadType === 'file') {
      if (!uploader.options.pick.multiple) {
        //删除已有文件
        list.find('li.file-item').remove();
      }
      var $filepart = '<li id="' + file.id + '" class="file-item">'
        + '<div class="file-title">' + file.name + ' <small>(' + file.size/1000000 + 'MB)</small></div>';
      if (config.showStatus) {
        $filepart += '<p class="state">等待上传</p>'
      }
      $filepart += '</li>';
      list.prepend($filepart);

    }
  });

  // 文件上传过程中创建进度条实时显示。
  uploader.on('uploadProgress', function (file, percentage) {
    var li = $('#' + file.id),
      percent = li.find('.progress-bar');
    if (config.uploadType === 'image') {
      // 避免重复创建
      if (!percent.length) {
        percent = $('<div class="progress-bar" role="progressbar" style="width: 0%">')
          .appendTo(li);
      }
      li.find('p.state').text('上传中');
      percent.css('width', percentage * 100 + '%');

    } else if (config.uploadType === 'file') {
      // 避免重复创建
      if (!percent.length) {
        percent = $('<div class="progress"><div class="progress-bar  progress-bar-success"></div></div>')
          .appendTo(li);
      }
      li.find('p.state').text('上传中');
      li.find('.progress-bar').css('width', percentage * 100 + '%');
    }
  });

  uploader.on('uploadSuccess', function (file, resp) {
    if (resp.result) {
      $('#' + file.id).find('p.state').text('已上传');
      if (config.showDestroy) {
        $('<a href="' + '/upload/' + resp.id + '?file_id=' +
          file.id + '&protect_token=' + resp.protect_token + '" data-remote="true" class="delete" data-method="delete">x</a>').appendTo($('#' + file.id));
      }
      $('<input type="hidden" name="' + webuploader.data('name') + '" value="' + resp.id + '" class="assetid">').appendTo($('#' + file.id));
      var img = list.find('#' + file.id + ' img');
      if (resp.url) {
        //img.attr('src', resp.url).attr('width', config.thumbnailWidth).attr('height', thumbnailHeight);
      }
      //增加一个回调
      if (config.afterUpload) {
        config.afterUpload(webuploader, resp);
      }
    } else {
      $('#' + file.id).find('p.state').text('上传失败，请重试');
      alert('上传的文件格式或大小错误');
    }

  });

  uploader.on('uploadError', function (file) {
    $('#' + file.id).find('p.state').text('上传失败，请重试');
      alert('上传失败，请重试');
  });

  uploader.on('uploadComplete', function (file) {
    $('#' + file.id).find('.progress-bar, .progress').fadeOut();
  });
  uploader.on('error', function (type) {
    if (type == 'F_EXCEED_SIZE') {
      alert('上传的文件太大');
    }
  })
}

function initImageWebuploader(el, config) {
  var picker = $(el).find('.upload-pick');
  if (!config) {
    config = {}
  }
  config = $.extend({
    uploadType: 'image',
    uploaderConfig: {
      pick: { id: picker, multiple: false },
      accept: {
        title: '请选择单张图片',
        extensions: 'gif,jpg,jpeg,bmp,png,svg',
        mimeTypes: 'image/gif,image/jpeg,image/bmp,image/png,image/svg+xml'
      }
    }
  }, config)
  initWebuploader($(el), config);
}

function initAvatarWebuploader(el, config) {
    var picker = $(el).find('.upload-pick');
    if (!config) {
        config = {}
    }
    config = $.extend({
        uploadType: 'image',
        uploaderConfig: {
            pick: { id: picker, multiple: false },
            accept: {
                title: '请选择单张图片',
                extensions: 'gif,jpg,jpeg,bmp,png,svg',
                mimeTypes: 'image/gif,image/jpeg,image/bmp,image/png,image/svg+xml'
            }
        },
        showDestroy: false,
        showStatus: false
    }, config)
    initWebuploader($(el), config);
}

function initMultiImageWebuploader(el, config, image_count) {
  var picker = $(el).find('.upload-pick');
  if (!config) {
    config = {}
  }
  config = $.extend({
    uploadType: 'image',
    uploaderConfig: {
      pick: { id: picker, multiple: true },
      accept: {
        title: '请选择多张图片',
        extensions: 'gif,jpg,jpeg,bmp,png,svg',
        mimeTypes: 'image/gif,image/jpeg,image/bmp,image/png,image/svg+xml'
      }
    }
  }, config)
  initWebuploader($(el), config, image_count);
}

function initAssetWebuploader(el, config) {
  var picker = $(el).find('.upload-pick');
  if (!config) {
    config = {}
  }
  config = $.extend({
    uploadType: 'file',
    uploaderConfig: {
      pick: { id: picker, multiple: false },
      accept: {
        title: '请选择单个附件',
        mimeTypes: 'asset/*'
      }
    }
  }, config)
  initWebuploader($(el), config);
}


function initExcelWebuploader(el, config) {
    var picker = $(el).find('.upload-pick');
    if (!config) {
        config = {}
    }
    config = $.extend({
        uploadType: 'file',
        uploaderConfig: {
            pick: { id: picker, multiple: false },
            accept: {
                title: '请选择单个附件',
                mimeTypes: 'application/vnd.ms-excel, application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
            }
        }
    }, config)
    initWebuploader($(el), config);
}

function initMultiAssetWebuploader(el, config, file_count) {
    var picker = $(el).find('.upload-pick');
    if (!config) {
        config = {}
    }
    config = $.extend({
        uploadType: 'file',
        uploaderConfig: {
            pick: { id: picker, multiple: true },
            accept: {
                title: '请选择附件',
                mimeTypes: 'asset/*'
            }
        }
    }, config)
    initWebuploader($(el), config, file_count);
}
