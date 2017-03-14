module ApplicationHelper

  def title(page_title)
    content_for :title, page_title.to_s
  end

  def meta_tag(descr)
    content_for :description, descr.to_s
  end

  def facebook_og_title(name)
    content_for :og_title, name.to_s
  end

  def facebook_image(url)
    content_for :facebook_image, url
  end

  def twitter_image(url)
    content_for :twitter_image, url
  end

  def facebook_secure_image(url)
    content_for :facebook_secure_image, url
  end

  def facebook_url(url)
    content_for :url, url.to_s
  end

  def dollar_format(value)
    number_with_precision(value, :precision => 2, :delimiter => ',')
  end

  def current_date
    Date.today.strftime("%b %e, %Y")
  end

  def date_format(date)
    date.strftime("%b %e, %Y")
  end

  def all_states
    [
        ['Delaware', 'DE'],
        ['Alabama', 'AL'],
        ['Alaska', 'AK'],
        ['Arizona', 'AZ'],
        ['Arkansas', 'AR'],
        ['California', 'CA'],
        ['Colorado', 'CO'],
        ['Connecticut', 'CT'],
        ['Delaware', 'DE'],
        ['District of Columbia', 'DC'],
        ['Florida', 'FL'],
        ['Georgia', 'GA'],
        ['Hawaii', 'HI'],
        ['Idaho', 'ID'],
        ['Illinois', 'IL'],
        ['Indiana', 'IN'],
        ['Iowa', 'IA'],
        ['Kansas', 'KS'],
        ['Kentucky', 'KY'],
        ['Louisiana', 'LA'],
        ['Maine', 'ME'],
        ['Maryland', 'MD'],
        ['Massachusetts', 'MA'],
        ['Michigan', 'MI'],
        ['Minnesota', 'MN'],
        ['Mississippi', 'MS'],
        ['Missouri', 'MO'],
        ['Montana', 'MT'],
        ['Nebraska', 'NE'],
        ['Nevada', 'NV'],
        ['New Hampshire', 'NH'],
        ['New Jersey', 'NJ'],
        ['New Mexico', 'NM'],
        ['New York', 'NY'],
        ['North Carolina', 'NC'],
        ['North Dakota', 'ND'],
        ['Ohio', 'OH'],
        ['Oklahoma', 'OK'],
        ['Oregon', 'OR'],
        ['Pennsylvania', 'PA'],
        ['Puerto Rico', 'PR'],
        ['Rhode Island', 'RI'],
        ['South Carolina', 'SC'],
        ['South Dakota', 'SD'],
        ['Tennessee', 'TN'],
        ['Texas', 'TX'],
        ['Utah', 'UT'],
        ['Vermont', 'VT'],
        ['Virginia', 'VA'],
        ['Washington', 'WA'],
        ['West Virginia', 'WV'],
        ['Wisconsin', 'WI'],
        ['Wyoming', 'WY']
      ]
  end

  def all_month
    [
        ['January', '01'],
        ['February', '02'],
        ['March', '03'],
        ['April', '04'],
        ['May', '05'],
        ['June', '06'],
        ['July', '07'],
        ['August', '08'],
        ['September', '09'],
        ['October', '10'],
        ['November', '11'],
        ['December', '12']
      ]
  end

  def all_dates
    [
      [1,1],
      [2,2],
      [3, 3],
      [4, 4],
      [5, 5],
      [6, 6],
      [7, 7],
      [8, 8],
      [9, 9],
      [10, 10],
      [11, 11],
      [12, 12],
      [13, 13],
      [14, 14],
      [15, 15],
      [16, 16],
      [17, 17],
      [18, 18],
      [19, 19],
      [20, 20],
      [21, 21],
      [22, 22],
      [23, 23],
      [24, 24],
      [25, 25],
      [26, 26],
      [27, 27],
      [28, 28],
      [29, 29],
      [30, 30],
      [31, 31]
    ]
  end
end

