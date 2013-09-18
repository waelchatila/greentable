Greentable
==========

Rails declarative html tables with export (csv,xls,pdf,xml) features.

Please note that export module is still under development.

Tested on rails 3.2 only using ruby 1.9.3

## Installation
gem 'greentable'

## Usage
The Greentable gem provides two methods only. To produce a table from an array of elements, do the following in a view:

```haml
=greentable(users) do |gt,user|
  - gt.col('NAME') do
    =user.name
  - gt.col('EMAIL') do
    =user.email
```

which will produce the following html:

```html
<table>
    <thead>
        <tr>
          <th>NAME</th>
          <th>EMAIL</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>Joe Ruby</td>
            <td>jruby@example.com</td>
        </tr>
        <tr>
            <td>Donald Rails</td>
            <td>drails@example.com</td>
        </tr>
    </tbody>
</table>
```

## Optional Options

Both greentable and greentable.col may be called with an optional hash

```haml
=greentable(array, class: 'a', style: 'b:c', tr: {class: 'd'}, th: {onclick: 'e();'}, td: {'data-target' => 'f'} ) do |gt, el|
  -gt.col('Col 1', class: 'g', th: {class: 'h'}) do
    = el.col1
  -gt.col('Col 2') do
    = el.col2
```

will produce

```html
<table class='a' style='b:c'>
    <thead>
        <tr class='d'>
          <th class='h' onclick='e();'>Col 1</th>
          <th onclick='e();'>Col 2</th>
        </tr>
    </thead>
    <tbody>
        <tr class='d'>
            <td class='g' data-target='f'>...</td>
            <td data-target='f'>...</td>
        </tr>
    </tbody>
</table>
```

If you need column names or options to be a little more dynamic, you can use procs:

```haml
=greentable(years) do |gt,year|
  -gt.col('Year') do
    =year.to_s
  -52.times do |week|
    -gt.col(Proc.new{ week % 2 == 0 ? 'An even week' : 'An odd week' }, td: {style: Proc.new{ year % 2 == 1 ? 'background-color:red' : nil }} ) do
      =week
```

will produce

```html
<table>
    <thead>
        <tr>
          <th>Year</th>
          <th>An even week</th>
          <th>An odd week</th>
          <th>An even week</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>2013</td>
            <td>0</td>
            <td style='background-color:red'>1</td>
            <td>2</td>
            <td style='background-color:red'>3</td>
            ...
        </tr>
        <tr>
            <td>2014</td>
            <td>0</td>
            <td style='background-color:red'>1</td>
            <td>2</td>
            <td style='background-color:red'>3</td>
            ...
        </tr>
        ...
    </tbody>
</table>
```


## Global Defaults Options
You can configure global default for your greentables.

In config/initializers/greentable.rb

```ruby
Greentable.configure do |config|
  config.defaults = {class: 'myTableClass', th: {style: 'cursor:pointer'}, td: {class: 'pi', onclick: 'alert(3.14159265359)'}}
end

...

<%= greentable([3.14]) do |gt,element| %>
    <%  gt.col('First Column') do %>
        <%= element %>
    <% end %>
<% end %>
```

will produce

```html
<table class='myTableClass'>
    <thead>
        <tr>
          <th style='cursor:pointer'>First Column</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td class='pi' onclick='alert(3.14159265359)'>3.14</td>
        </tr>
    </tbody>
</table>

## Green Export

Greentable enables you to export your greentable data for download in various formats seamlessly by a rack middleware.


[Still under development]


