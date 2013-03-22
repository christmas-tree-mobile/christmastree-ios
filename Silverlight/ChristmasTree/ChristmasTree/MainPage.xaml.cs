using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Windows;
using System.IO;
using System.IO.IsolatedStorage;
using System.Windows.Controls;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Resources;
using System.Windows.Shapes;
using System.Windows.Threading;
using Microsoft.Phone.Controls;
using Microsoft.Phone.Tasks;
using Microsoft.Xna.Framework.Media;

namespace ChristmasTree
{
    public partial class MainPage : PhoneApplicationPage
    {
        private bool isMoveToy;
        private Image dragImage;
        private Image moveImage;
        private DispatcherTimer timerCreateToy;
        private DispatcherTimer timerHideToy;
        private BitmapImage biCreateToy;
        private Point lastPointMove;
        private Point firstPointMove;
        private Point firstPointHideToy;

        private WriteableBitmap btmScreenshot;
        
        private int upperTreePointX = 240;
        private int upperTreePointY = 50;
        private int lowerLeftTreePointX = 25;
        private int lowerLeftTreePointY = 670;
        private int lowerRightTreePointX = 450;
        private int lowerRightTreePointY = 670;

        private int countAnimationStart;

        private string backgroundSettings;
        private string treeSettings;
        private string treeLayerSettings;
        private string volumeSettings;

        private MarketplaceDetailTask marketplaceDetailTask;

        private string defaultTree = "/Images/tree-1-bg.png";
        private string defaultTreeLayer = "/Images/tree-1-fg.png";
        private string defaultBackground = "/Images/bg-1.png";
        private double defaultVolume = 0.75;

        public MainPage()
        {
            InitializeComponent();

            this.isMoveToy = false;
            this.dragImage = null;
            this.countAnimationStart = 0;

            for (int i = 1; i <= 37; i++)
            {
                this.ItemListBox.Items.Add(new ChristmasItem("/Images/toys/toy-" + i.ToString() + ".png"));
            }
            for (int i = 1; i <= 7; i++)
            {
                this.ItemListBox.Items.Add(new ChristmasItem("/Images/toys/twinkle-" + i.ToString() + ".png"));
            }

            this.timerCreateToy = new System.Windows.Threading.DispatcherTimer();
            this.timerCreateToy.Tick += new EventHandler(timerCreateToy_Tick);
            this.timerCreateToy.Interval = new TimeSpan(0, 0, 0, 0, 200);

            this.timerHideToy = new System.Windows.Threading.DispatcherTimer();
            this.timerHideToy.Tick += new EventHandler(timerHideToy_Tick);
            this.timerHideToy.Interval = new TimeSpan(0, 0, 0, 0, 500);

            this.marketplaceDetailTask                   = new MarketplaceDetailTask();
#if DEBUG_TRIAL
            this.marketplaceDetailTask.ContentType       = MarketplaceContentType.Applications;
            this.marketplaceDetailTask.ContentIdentifier = "ca7b1704-42b5-4208-be23-e280d04e662c";
#endif
        }

        protected override void OnNavigatedTo(NavigationEventArgs e)
        {
            IsolatedStorageSettings.ApplicationSettings.TryGetValue<string>("background_string", out this.backgroundSettings);

            if (this.backgroundSettings == "" || this.backgroundSettings == null)
            {
                this.backgroundSettings = this.defaultBackground;

                IsolatedStorageSettings.ApplicationSettings.Add("background_string", this.backgroundSettings);
                IsolatedStorageSettings.ApplicationSettings.Save();
            }

            IsolatedStorageSettings.ApplicationSettings.TryGetValue<string>("tree_layer_string", out this.treeLayerSettings);            

            if (this.treeLayerSettings == "" || this.treeLayerSettings == null) 
            {
                this.treeLayerSettings = this.defaultTreeLayer;

                IsolatedStorageSettings.ApplicationSettings.Add("tree_layer_string", this.treeLayerSettings);
                IsolatedStorageSettings.ApplicationSettings.Save();
            }

            IsolatedStorageSettings.ApplicationSettings.TryGetValue<string>("tree_string", out this.treeSettings);

            if (this.treeSettings == "" || this.treeSettings == null)
            {
                this.treeSettings = this.defaultTree;

                IsolatedStorageSettings.ApplicationSettings.Add("tree_string", this.treeSettings);
                IsolatedStorageSettings.ApplicationSettings.Save();
            }

            this.BackgroundImage.Source = new BitmapImage(new Uri(this.backgroundSettings, UriKind.Relative));
            this.TreeImage.Source = new BitmapImage(new Uri(this.treeSettings, UriKind.Relative));
            this.TreeImageLayer.Source = new BitmapImage(new Uri(this.treeLayerSettings, UriKind.Relative));

            IsolatedStorageSettings.ApplicationSettings.TryGetValue<string>("volume_string", out this.volumeSettings);

            if (this.volumeSettings == "" || this.volumeSettings == null)
            {
                this.volumeSettings = Convert.ToString(this.defaultVolume);

                IsolatedStorageSettings.ApplicationSettings.Add("volume_string", this.volumeSettings);
                IsolatedStorageSettings.ApplicationSettings.Save();
            }

            try
            {
                this.mediaElement.Volume = Convert.ToDouble(this.volumeSettings);
            }
            catch (Exception)
            {
                this.mediaElement.Volume = this.defaultVolume;
            }

            if ((Application.Current as App).HasMusicControl)
            {
                this.mediaElement.Source = new Uri("/Sound/music.mp3", UriKind.Relative);
                this.mediaElement.Play();
            }
        }

        private bool validateToy(int center_x, int center_y)
        {
            var x0 = center_x;
            var x1 = this.upperTreePointX;
            var x2 = this.lowerLeftTreePointX;
            var x3 = this.lowerRightTreePointX;

            var y0 = center_y;
            var y1 = this.upperTreePointY;
            var y2 = this.lowerLeftTreePointY;
            var y3 = this.lowerRightTreePointY;

            var mul1 = (x1 - x0) * (y2 - y1) - (x2 - x1) * (y1 - y0);
            var mul2 = (x2 - x0) * (y3 - y2) - (x3 - x2) * (y2 - y0);
            var mul3 = (x3 - x0) * (y1 - y3) - (x1 - x3) * (y3 - y0);

            if ((mul1 > 0 && mul2 > 0 && mul3 > 0) || (mul1 < 0 && mul2 < 0 && mul3 < 0))
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        private void destroyToy(Image item)
        {
            Storyboard sb = new Storyboard();
            DoubleAnimation fallAnimation = new DoubleAnimation();

            fallAnimation.From = 0;
            fallAnimation.To = this.ToyGrid.ActualHeight * 2;
            fallAnimation.Duration = new Duration(TimeSpan.FromSeconds(0.2));

            Storyboard.SetTarget(fallAnimation, item);
            Storyboard.SetTargetProperty(fallAnimation, new PropertyPath("(UIElement.RenderTransform).(TranslateTransform.Y)"));

            sb.Completed += new EventHandler(storyFall_Completed);
            sb.Children.Add(fallAnimation);
            sb.Begin();

            this.countAnimationStart++;
        }

        private void timerHideToy_Tick(object sender, EventArgs e)
        {
            timerHideToy.Stop();

            if (Canvas.GetZIndex(this.moveImage) == 3)
            {
                Canvas.SetZIndex(this.moveImage, 7);
            }
            else
            {
                Canvas.SetZIndex(this.moveImage, 3);
            }
        }

        private void timerCreateToy_Tick(object sender, EventArgs e)
        {
            timerCreateToy.Stop();

            int width = this.biCreateToy.PixelWidth * 2;
            int height = this.biCreateToy.PixelHeight * 2;
            int x = (int)(this.lastPointMove.X) - width / 2;
            int y = (int)(this.lastPointMove.Y) - height;            
            string path_img = Convert.ToString(this.biCreateToy.UriSource);

            this.dragImage = new Image();
            this.dragImage.Source = new BitmapImage(this.biCreateToy.UriSource);
            this.dragImage.Width = width;
            this.dragImage.Height = height;
            this.dragImage.Margin = new Thickness(x, y, this.ToyGrid.ActualWidth - x - width, this.ToyGrid.ActualHeight - y - height);
            this.dragImage.RenderTransform = new TranslateTransform() { X = 0, Y = 0 };
            this.dragImage.MouseLeftButtonDown += new MouseButtonEventHandler(dragImage_MouseLeftButtonDown);
            this.dragImage.MouseMove += new MouseEventHandler(dragImage_MouseMove);
            this.dragImage.MouseLeftButtonUp += new MouseButtonEventHandler(dragImage_MouseLeftButtonUp);

            Canvas.SetZIndex(this.dragImage, 7);

            if (path_img.IndexOf("twinkle") > -1)
            {
                Storyboard sb = new Storyboard();
                DoubleAnimation twinkleAnimation = new DoubleAnimation();

                twinkleAnimation.From = 1;
                twinkleAnimation.To = 0.0;
                twinkleAnimation.Duration = new Duration(TimeSpan.FromSeconds(1.0));

                Storyboard.SetTarget(twinkleAnimation, this.dragImage);
                Storyboard.SetTargetProperty(twinkleAnimation, new PropertyPath("(UIElement.Opacity)"));

                sb.Children.Add(twinkleAnimation);
                sb.Completed += new EventHandler(storyTwinkle_Completed);
                sb.Begin();
            }

            this.ToyGrid.Children.Add(this.dragImage);
            this.isMoveToy = true;
        }

        private void storyTwinkle_Completed(object sender, EventArgs e)
        {
            Storyboard story = (sender as Storyboard);

            if ((story.Children[0] as DoubleAnimation).From == 1.0)
            {
                (story.Children[0] as DoubleAnimation).From = 0.0;
            }
            else
            {
                (story.Children[0] as DoubleAnimation).From = 1.0;
            }

            if ((story.Children[0] as DoubleAnimation).To == 1.0)
            {
                (story.Children[0] as DoubleAnimation).To = 0.0;
            }
            else
            {
                (story.Children[0] as DoubleAnimation).To = 1.0;
            }

            try
            {
                story.Begin();
            }
            catch (Exception)
            {
                // This exception is thrown when target doesn't exist anymore (e.g. on exiting), so silently ignore it
            }
        }

        private void storyFall_Completed(object sender, EventArgs e)
        {
            this.countAnimationStart--;

            if (this.countAnimationStart == 0)
            {
                List<Image> ImagesListToy = new List<Image>();
                var images = this.ToyGrid.Children.OfType<Image>();

                foreach (var img in images)
                {
                    if ((img.RenderTransform as TranslateTransform) != null &&
                        (img.RenderTransform as TranslateTransform).Y > this.ToyGrid.ActualHeight)
                    {
                        ImagesListToy.Add(img);
                    }
                }
                foreach (var img_delete in ImagesListToy)
                {
                    this.ToyGrid.Children.Remove(img_delete);
                }
            }
        }

        private void dragImage_MouseLeftButtonDown(object sender, MouseButtonEventArgs e)
        {
            Image item = sender as Image;

            item.Width = item.ActualWidth * 2;
            item.Height = item.ActualHeight * 2;

            Point point = e.GetPosition(this.ToyGrid);

            item.Margin = new Thickness(point.X - item.Width / 2, point.Y - item.Height / 2 - item.Height, this.ToyGrid.ActualWidth - point.X - item.Width / 2, this.ToyGrid.ActualHeight - point.Y - item.Height / 2);
            
            this.moveImage = item;

            timerHideToy.Start();
            
            this.firstPointHideToy = point;
            
            item.CaptureMouse();
        }

        void dragImage_MouseMove(object sender, MouseEventArgs e)
        {
            Image item = sender as Image;
            Point point = e.GetPosition(this.ToyGrid);

            if (Math.Abs(point.X - this.firstPointHideToy.X) > 16 || Math.Abs(point.Y - this.firstPointHideToy.Y) > 16)
            {
                timerHideToy.Stop();
            }

            int x = (int)(point.X - item.ActualWidth / 2);
            int y = (int)(point.Y - item.ActualHeight);

            item.Margin = new Thickness(x, y, this.ToyGrid.ActualWidth - x - item.ActualWidth, this.ToyGrid.ActualHeight - y - item.ActualHeight);
        }

        void dragImage_MouseLeftButtonUp(object sender, MouseButtonEventArgs e)
        {
            Image item = sender as Image;
            Point point = e.GetPosition(this.ToyGrid);

            int width = (int)(item.ActualWidth) / 2;
            int height = (int)(item.ActualHeight) / 2;
            int x = (int)(point.X - width / 2);
            int y = (int)(point.Y - height * 2);

            item.Height = height;
            item.Width = width;
            item.Margin = new Thickness(x, y, this.ToyGrid.ActualWidth - x - width, this.ToyGrid.ActualHeight - y - height);

            if (!validateToy((int)(x + height / 2), (int)(y + width / 2)))
            {
                destroyToy(item);
            }

            item.ReleaseMouseCapture();
        }

        private void mediaElement_MediaEnded(object sender, RoutedEventArgs e)
        {
            if ((Application.Current as App).HasMusicControl)
            {
                this.mediaElement.Source = new Uri("/Sound/music.mp3", UriKind.Relative);
                this.mediaElement.Play();
            }
        }

        private void Image_MouseLeftButtonDown(object sender, MouseButtonEventArgs e)
        {
            this.lastPointMove = e.GetPosition(this.ToyGrid);

            if (this.dragImage == null && !this.isMoveToy)
            {
                Image item = sender as Image;                
                biCreateToy = item.Source as BitmapImage;
                timerCreateToy.Start();
                item.CaptureMouse();
                this.firstPointMove = this.lastPointMove;
            }            
        }

        private void Image_MouseMove(object sender, MouseEventArgs e)
        {
            this.lastPointMove = e.GetPosition(this.ToyGrid);

            if (!this.isMoveToy)
            {
                Image item = sender as Image;

                if ((item.Source as BitmapImage) != this.biCreateToy)
                {
                    timerCreateToy.Stop();
                    this.dragImage = null;
                    this.isMoveToy = false;
                    return;
                }
                if (Math.Abs(this.lastPointMove.X - this.firstPointMove.X) > 16 || Math.Abs(this.lastPointMove.Y - this.firstPointMove.Y) > 16)
                {
                    timerCreateToy.Stop();
                    this.dragImage = null;
                    this.isMoveToy = false;
                    return;
                }
            }

            if (this.dragImage != null && this.isMoveToy)
            {
                Point point = e.GetPosition(this.ToyGrid);
                this.dragImage.Margin = new Thickness(point.X - this.dragImage.Width / 2, point.Y - this.dragImage.Height / 2 - this.dragImage.Height, this.ToyGrid.ActualWidth - point.X - this.dragImage.Width / 2, this.ToyGrid.ActualHeight - point.Y - this.dragImage.Height / 2);
            }
        }

        private void Image_MouseLeftButtonUp(object sender, MouseButtonEventArgs e)
        {
            timerCreateToy.Stop();

            this.lastPointMove = e.GetPosition(this.ToyGrid);

            if (this.dragImage != null)
            {
                Point point = e.GetPosition(this.ToyGrid);
                int width = (int)(this.dragImage.ActualWidth) / 2;
                int height = (int)(this.dragImage.ActualHeight) / 2;
                int x = (int)(point.X - width / 2);
                int y = (int)(point.Y - height * 2);
                this.dragImage.Height = height;
                this.dragImage.Width = width;
                this.dragImage.Margin = new Thickness(x, y, this.ToyGrid.ActualWidth - x - width, this.ToyGrid.ActualHeight - y - height);
                if (!validateToy(x + width / 2, y + height / 2))
                {
                    destroyToy(this.dragImage);
                }
                this.dragImage = null;

                this.isMoveToy = false;
            }

            (sender as Image).ReleaseMouseCapture();
        }

        private void Image_MouseLeave(object sender, MouseEventArgs e)
        {
            timerCreateToy.Stop();

            this.dragImage = null;
            this.isMoveToy = false;
        }

        private void Image_ManipulationStarted(object sender, ManipulationStartedEventArgs e)
        {
            if (this.dragImage != null && this.isMoveToy)
            {
                e.Handled = true;
                e.Complete();
            }
        }

        private void Image_ManipulationDelta(object sender, ManipulationDeltaEventArgs e)
        {
            if (this.dragImage != null && this.isMoveToy)
            {
                e.Handled = true;
                e.Complete();
            }
        }

        private void Image_ManipulationCompleted(object sender, ManipulationCompletedEventArgs e)
        {
            if (this.dragImage != null && this.isMoveToy)
            {
                e.Handled = true;
            }
        }

        private void ImgBtnHelp_MouseLeftButtonUp(object sender, MouseButtonEventArgs e)
        {
            NavigationService.Navigate(new Uri("/HelpPage.xaml", UriKind.Relative));
        }

        private void ImgBtnSettings_MouseLeftButtonUp(object sender, MouseButtonEventArgs e)
        {
            NavigationService.Navigate(new Uri("/SettingsPage.xaml", UriKind.Relative));
        }

        private void ImgBtnToys_MouseLeftButtonUp(object sender, MouseButtonEventArgs e)
        {
            if (this.ItemListBox.Visibility == Visibility.Collapsed)
            {
                Image item = sender as Image;
                item.Source = new BitmapImage(new Uri("/Images/buttons/toys-pressed.png", UriKind.Relative));
                this.ItemListBox.Visibility = Visibility.Visible;
            }
            else {
                Image item = sender as Image;
                item.Source = new BitmapImage(new Uri("/Images/buttons/toys.png", UriKind.Relative));
                this.ItemListBox.Visibility = Visibility.Collapsed;
            }
        }

        private void ImgBtnCapture_MouseLeftButtonUp(object sender, MouseButtonEventArgs e)
        {
            if ((Application.Current as App).TrialMode)
            {
                MessageBoxResult result = MessageBox.Show(AppResources.MessageBoxMessageImageSaveTrialVersionQuestion, AppResources.MessageBoxHeaderInfo, MessageBoxButton.OKCancel);

                if (result == MessageBoxResult.OK)
                {
                    try
                    {
                        this.marketplaceDetailTask.Show();
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show(AppResources.MessageBoxMessageMarketplaceOpenError + " " + ex.Message.ToString(), AppResources.MessageBoxHeaderError, MessageBoxButton.OK);
                    }
                }
            }
            else
            {
                this.btmScreenshot = new WriteableBitmap((int)this.ToyGrid.ActualWidth, (int)this.ToyGrid.ActualHeight);
                this.btmScreenshot.Clear(Colors.Black);

                WriteableBitmap bmp_toy;

                var images = this.ToyGrid.Children.OfType<Image>();
                List<Image> ImagesListScreen = new List<Image>();

                foreach (var img in images)
                {
                    int index = Canvas.GetZIndex(img);
                    if (ImagesListScreen.Count == 0)
                    {
                        ImagesListScreen.Add(img);
                        continue;
                    }
                    bool f_add = false;
                    foreach (var img_list in ImagesListScreen)
                    {
                        int index_list = Canvas.GetZIndex(img_list);
                        if (index <= index_list)
                        {
                            ImagesListScreen.Insert(ImagesListScreen.IndexOf(img_list), img);
                            f_add = true;
                            break;
                        }
                    }
                    if (f_add == false) ImagesListScreen.Add(img);
                }

                foreach (var img in ImagesListScreen)
                {
                    bmp_toy = new WriteableBitmap((int)(img.ActualWidth), (int)(img.ActualHeight));
                    bmp_toy.Render(img, new TranslateTransform() { X = 0, Y = 0 });
                    bmp_toy.Invalidate();
                    this.btmScreenshot.Blit(new Rect(img.Margin.Left, img.Margin.Top, img.ActualWidth, img.ActualHeight), bmp_toy, new Rect(0, 0, bmp_toy.PixelWidth, bmp_toy.PixelHeight)); //draw the frame                    
                }

                try
                {
                    using (IsolatedStorageFile store = IsolatedStorageFile.GetUserStoreForApplication())
                    {
                        string file_name = "image.jpg";

                        if (store.FileExists(file_name))
                        {
                            store.DeleteFile(file_name);
                        }

                        using (IsolatedStorageFileStream stream = store.CreateFile(file_name))
                        {
                            this.btmScreenshot.SaveJpeg(stream, this.btmScreenshot.PixelWidth, this.btmScreenshot.PixelHeight, 0, 100);
                        }

                        using (IsolatedStorageFileStream stream = store.OpenFile(file_name, FileMode.Open, FileAccess.Read))
                        {
                            using (MediaLibrary library = new MediaLibrary())
                            {
                                library.SavePicture(file_name, stream);
                            }
                        }

                        store.DeleteFile(file_name);
                    }

                    MessageBox.Show(AppResources.MessageBoxMessageImageSavedInfo, AppResources.MessageBoxHeaderInfo, MessageBoxButton.OK);
                }
                catch (Exception ex)
                {
                    MessageBox.Show(AppResources.MessageBoxMessageImageSaveError + " " + ex.Message.ToString(), AppResources.MessageBoxHeaderError, MessageBoxButton.OK);
                }
            }
        }
    }
    
    public class ChristmasItem
    {
        public String ImageSource { get; set; }

        public ChristmasItem(String type)
        {
            this.ImageSource = type;
        }
    }
}