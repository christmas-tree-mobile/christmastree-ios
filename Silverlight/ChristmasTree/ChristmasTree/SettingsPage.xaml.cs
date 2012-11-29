using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.IO.IsolatedStorage;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Navigation;
using System.Windows.Shapes;
using Microsoft.Phone.Controls;

namespace ChristmasTree
{
    public partial class SettingsPage : PhoneApplicationPage
    {
        private string tree1 = "/Images/tree-1-bg.png";
        private string tree2 = "/Images/tree-2-bg.png";
        private string tree3 = "/Images/tree-3-bg.png";

        private string background1 = "/Images/bg-1.png";
        private string background2 = "/Images/bg-2.png";
        private string background3 = "/Images/bg-3.png";

        private string treeLayer1 = "/Images/tree-1-fg.png";
        private string treeLayer2 = "/Images/tree-2-fg.png";
        private string treeLayer3 = "/Images/tree-3-fg.png";

        private string backgroundSettings;
        private string treeSettings;
        private string treeLayerSettings;
        private string volumeSettings;

        private double defaultVolume = 0.75;

        public SettingsPage()
        {
            InitializeComponent();
        }

        protected override void OnNavigatedTo(NavigationEventArgs e)
        {
            IsolatedStorageSettings.ApplicationSettings.TryGetValue<string>("background_string", out this.backgroundSettings);

            if (this.backgroundSettings == "" || this.backgroundSettings == null)
            {
                this.backgroundSettings = this.background1;

                IsolatedStorageSettings.ApplicationSettings.Add("background_string", this.backgroundSettings);
                IsolatedStorageSettings.ApplicationSettings.Save();
            }

            if (this.backgroundSettings == this.background1)
            {
                this.borderBg1.BorderBrush = new SolidColorBrush(Colors.White);
                this.borderBg2.BorderBrush = new SolidColorBrush(Colors.Transparent);
                this.borderBg3.BorderBrush = new SolidColorBrush(Colors.Transparent);
            }
            if (this.backgroundSettings == this.background2)
            {
                this.borderBg1.BorderBrush = new SolidColorBrush(Colors.Transparent);
                this.borderBg2.BorderBrush = new SolidColorBrush(Colors.White);
                this.borderBg3.BorderBrush = new SolidColorBrush(Colors.Transparent);
            }
            if (this.backgroundSettings == this.background3)
            {
                this.borderBg1.BorderBrush = new SolidColorBrush(Colors.Transparent);
                this.borderBg2.BorderBrush = new SolidColorBrush(Colors.Transparent);
                this.borderBg3.BorderBrush = new SolidColorBrush(Colors.White);
            }

            IsolatedStorageSettings.ApplicationSettings.TryGetValue<string>("tree_string", out this.treeSettings);

            if (this.treeSettings == "" || this.treeSettings == null)
            {
                this.treeSettings = this.tree1;

                IsolatedStorageSettings.ApplicationSettings.Add("tree_string", this.treeSettings);
                IsolatedStorageSettings.ApplicationSettings.Save();
            }

            if (this.treeSettings == this.tree1)
            {
                this.borderTr1.BorderBrush = new SolidColorBrush(Colors.White);
                this.borderTr2.BorderBrush = new SolidColorBrush(Colors.Transparent);
                this.borderTr3.BorderBrush = new SolidColorBrush(Colors.Transparent);
            }
            if (this.treeSettings == this.tree2)
            {
                this.borderTr1.BorderBrush = new SolidColorBrush(Colors.Transparent);
                this.borderTr2.BorderBrush = new SolidColorBrush(Colors.White);
                this.borderTr3.BorderBrush = new SolidColorBrush(Colors.Transparent);
            }
            if (this.treeSettings == this.tree3)
            {
                this.borderTr1.BorderBrush = new SolidColorBrush(Colors.Transparent);
                this.borderTr2.BorderBrush = new SolidColorBrush(Colors.Transparent);
                this.borderTr3.BorderBrush = new SolidColorBrush(Colors.White);
            }

            IsolatedStorageSettings.ApplicationSettings.TryGetValue<string>("volume_string", out this.volumeSettings);

            if (this.volumeSettings == "" || this.volumeSettings == null)
            {
                this.volumeSettings = Convert.ToString(this.defaultVolume);

                IsolatedStorageSettings.ApplicationSettings.Add("volume_string", this.volumeSettings);
                IsolatedStorageSettings.ApplicationSettings.Save();
            }

            try
            {
                this.VolumeSlider.Value = Convert.ToDouble(this.volumeSettings);
            }
            catch (Exception)
            {
                this.VolumeSlider.Value = this.defaultVolume;
            }

            if ((Application.Current as App).HasMusicControl)
            {
                this.mediaElement.Source = new Uri("/Sound/music.mp3", UriKind.Relative);
                this.mediaElement.Play();
            }
        }

        private void mediaElement_MediaEnded(object sender, RoutedEventArgs e)
        {
            if ((Application.Current as App).HasMusicControl)
            {
                this.mediaElement.Source = new Uri("/Sound/music.mp3", UriKind.Relative);
                this.mediaElement.Play();
            }
        }

        private void imageBg1_MouseLeftButtonUp(object sender, MouseButtonEventArgs e)
        {
            this.backgroundSettings = this.background1;

            this.borderBg1.BorderBrush = new SolidColorBrush(Colors.White);
            this.borderBg2.BorderBrush = new SolidColorBrush(Colors.Transparent);
            this.borderBg3.BorderBrush = new SolidColorBrush(Colors.Transparent);

            IsolatedStorageSettings.ApplicationSettings["background_string"] = this.backgroundSettings;
            IsolatedStorageSettings.ApplicationSettings.Save();
        }

        private void imageBg2_MouseLeftButtonUp(object sender, MouseButtonEventArgs e)
        {
            this.backgroundSettings = this.background2;

            this.borderBg1.BorderBrush = new SolidColorBrush(Colors.Transparent);
            this.borderBg2.BorderBrush = new SolidColorBrush(Colors.White);
            this.borderBg3.BorderBrush = new SolidColorBrush(Colors.Transparent);

            IsolatedStorageSettings.ApplicationSettings["background_string"] = this.backgroundSettings;
            IsolatedStorageSettings.ApplicationSettings.Save();
        }

        private void imageBg3_MouseLeftButtonUp(object sender, MouseButtonEventArgs e)
        {
            this.backgroundSettings = this.background3;

            this.borderBg1.BorderBrush = new SolidColorBrush(Colors.Transparent);
            this.borderBg2.BorderBrush = new SolidColorBrush(Colors.Transparent);
            this.borderBg3.BorderBrush = new SolidColorBrush(Colors.White);

            IsolatedStorageSettings.ApplicationSettings["background_string"] = this.backgroundSettings;
            IsolatedStorageSettings.ApplicationSettings.Save();
        }

        private void imageTr1_MouseLeftButtonUp(object sender, MouseButtonEventArgs e)
        {
            this.treeSettings = this.tree1;
            this.treeLayerSettings = this.treeLayer1;

            this.borderTr1.BorderBrush = new SolidColorBrush(Colors.White);
            this.borderTr2.BorderBrush = new SolidColorBrush(Colors.Transparent);
            this.borderTr3.BorderBrush = new SolidColorBrush(Colors.Transparent);

            IsolatedStorageSettings.ApplicationSettings["tree_string"] = this.treeSettings;
            IsolatedStorageSettings.ApplicationSettings["tree_layer_string"] = this.treeLayerSettings;
            IsolatedStorageSettings.ApplicationSettings.Save();
        }

        private void imageTr2_MouseLeftButtonUp(object sender, MouseButtonEventArgs e)
        {
            this.treeSettings = this.tree2;
            this.treeLayerSettings = this.treeLayer2;

            this.borderTr1.BorderBrush = new SolidColorBrush(Colors.Transparent);
            this.borderTr2.BorderBrush = new SolidColorBrush(Colors.White);
            this.borderTr3.BorderBrush = new SolidColorBrush(Colors.Transparent);

            IsolatedStorageSettings.ApplicationSettings["tree_string"] = this.treeSettings;
            IsolatedStorageSettings.ApplicationSettings["tree_layer_string"] = this.treeLayerSettings;
            IsolatedStorageSettings.ApplicationSettings.Save();
        }

        private void imageTr3_MouseLeftButtonUp(object sender, MouseButtonEventArgs e)
        {
            this.treeSettings = this.tree3;
            this.treeLayerSettings = this.treeLayer3;

            this.borderTr1.BorderBrush = new SolidColorBrush(Colors.Transparent);
            this.borderTr2.BorderBrush = new SolidColorBrush(Colors.Transparent);
            this.borderTr3.BorderBrush = new SolidColorBrush(Colors.White);

            IsolatedStorageSettings.ApplicationSettings["tree_string"] = this.treeSettings;
            IsolatedStorageSettings.ApplicationSettings["tree_layer_string"] = this.treeLayerSettings;
            IsolatedStorageSettings.ApplicationSettings.Save();
        }

        private void VolumeSlider_ValueChanged(object sender, RoutedPropertyChangedEventArgs<double> e)
        {
            this.mediaElement.Volume = e.NewValue;

            IsolatedStorageSettings.ApplicationSettings["volume_string"] = Convert.ToString(this.mediaElement.Volume);
            IsolatedStorageSettings.ApplicationSettings.Save();
        }
    }
}