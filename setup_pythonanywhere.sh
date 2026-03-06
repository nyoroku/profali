#!/bin/bash
set -e

USERNAME="profalithewitchdoctor"
PROJECT_DIR="/home/${USERNAME}/profali"
VENV_DIR="/home/${USERNAME}/.virtualenvs/profali"

echo "=== Step 1: Recreate virtualenv with Python 3.13 ==="
rm -rf "$VENV_DIR"
python3.13 -m venv "$VENV_DIR"
source "${VENV_DIR}/bin/activate"
echo "Using: $(python --version)"

echo "=== Step 2: Install packages ==="
pip install --upgrade pip
pip install django django-crispy-forms crispy-tailwind django-imagekit django-tinymce pillow

echo "=== Step 3: Create media directories ==="
mkdir -p "${PROJECT_DIR}/media/services"
mkdir -p "${PROJECT_DIR}/media/testimonies"
mkdir -p "${PROJECT_DIR}/media/blogs"

echo "=== Step 4: Download images ==="
cd "${PROJECT_DIR}/media/services"
wget -q "https://images.unsplash.com/photo-1509114397022-ed747cca3f65?w=400&h=400&fit=crop" -O spiritual_cleansing.jpg || true
wget -q "https://images.unsplash.com/photo-1518199266791-5375a83190b7?w=400&h=400&fit=crop" -O love_unity.jpg || true
wget -q "https://images.unsplash.com/photo-1589829545856-d10d557cf95f?w=400&h=400&fit=crop" -O wealth_abundance.jpg || true
wget -q "https://images.unsplash.com/photo-1589829545856-d10d557cf95f?w=400&h=400&fit=crop" -O justice.jpg || true
wget -q "https://images.unsplash.com/photo-1471193945509-9ad0617afabf?w=400&h=400&fit=crop" -O herbal_healing.jpg || true

cd "${PROJECT_DIR}/media/testimonies"
wget -q "https://i.pravatar.cc/256?img=32" -O sarah.jpg || true
wget -q "https://i.pravatar.cc/256?img=60" -O john.jpg || true
wget -q "https://i.pravatar.cc/256?img=25" -O amina.jpg || true

cd "${PROJECT_DIR}/media/blogs"
wget -q "https://images.unsplash.com/photo-1471193945509-9ad0617afabf?w=400&h=400&fit=crop" -O herbs.jpg || true
wget -q "https://images.unsplash.com/photo-1509114397022-ed747cca3f65?w=400&h=400&fit=crop" -O cleansing.jpg || true

echo "=== Step 5: Run migrations ==="
cd "$PROJECT_DIR"
python manage.py migrate

echo "=== Step 6: Seed database ==="
python manage.py shell << 'PYEOF'
from rehab.models import Service, Testimony, Blog, Career
from django.contrib.auth.models import User

Service.objects.all().delete()
Testimony.objects.all().delete()
Blog.objects.all().delete()
Career.objects.all().delete()

Service.objects.create(name="Spiritual Cleansing & Protection", summary="Remove dark energies, evil spirits, and negative vibrations from your life and home.", body="<p>Our spiritual cleansing rituals use sacred herbs and ancestral wisdom to purge darkness and shield you from future harm.</p>", image="services/spiritual_cleansing.jpg")
Service.objects.create(name="Love & Relationship Harmony", summary="Bring back lost lovers, fix broken marriages, and attract your soulmate today.", body="<p>Prof Ali provides divine guidance and traditional remedies to restore peace in relationships and reunite separated hearts.</p>", image="services/love_unity.jpg")
Service.objects.create(name="Financial Prosperity & Success", summary="Unlock business growth, attract wealth, and enjoy financial luck in all your ventures.", body="<p>Prof Ali offers spiritual keys to unlock prosperity, attract new customers, and clear the path to success.</p>", image="services/wealth_abundance.jpg")
Service.objects.create(name="Court Cases & Legal Support", summary="Spiritual guidance and herbal support to ensure favorable outcomes in legal battles.", body="<p>Our traditional methods help clear the spiritual hurdles in your path, ensuring justice prevails in your favor.</p>", image="services/justice.jpg")
Service.objects.create(name="Natural Herbal Healing", summary="Traditional cures for chronic illnesses and ailments where conventional medicine fails.", body="<p>Harnessing the power of pure African herbs, Prof Ali treats long-standing physical and spiritual conditions with profound results.</p>", image="services/herbal_healing.jpg")

Testimony.objects.create(name="Sarah Mwangi", summary="Financial breakthrough", description="I had been struggling with my boutique for three years. After consulting Prof Ali, my business transformed completely. Customers are now coming from everywhere!", photo="testimonies/sarah.jpg")
Testimony.objects.create(name="John K.", summary="Marriage restored", description="My wife had left me for another man. Prof Ali helped me understand the spiritual blockages. Within two weeks, she returned and we are now closer than ever.", photo="testimonies/john.jpg")
Testimony.objects.create(name="Amina Mohammed", summary="Healing success", description="My son had a strange skin condition no doctor could cure. One visit to Prof Ali and his herbal medicine cleared it up in days. A true blessing!", photo="testimonies/amina.jpg")

Blog.objects.create(title="The Secret Power of Sacred Herbs", summary="Discover how nature provides everything we need for spiritual and physical wellness.", body="<p>Traditional African herbalism is not just about plants; it is about the spirit within them. We explore the most powerful herbs used in traditional African medicine.</p>", picture="blogs/herbs.jpg")
Blog.objects.create(title="Signs You Need a Spiritual Cleansing", summary="Learn to identify the warning signs of negative energy blockages before they cause harm.", body="<p>Constant fatigue, bad luck, recurring nightmares - these could be signs your spirit is under attack. Learn how to restore balance.</p>", picture="blogs/cleansing.jpg")

Career.objects.create(title="From Poverty to Prosperity: A Transformation Story", summary="See how one man's faith in traditional healing changed his family's legacy forever.", description="<p>Moses was a laborer struggling to feed his children. Through Prof Ali's guidance, he identified and cleared spiritual blockages. Today he is a successful landowner.</p>", status="open")
Career.objects.create(title="The Miracle of Reunited Hearts", summary="How spiritual alignment saved a family from the brink of divorce.", description="<p>Grace and Peter were about to divorce after 15 years. Prof Ali identified a spiritual disturbance caused by an envious neighbor. Peace was restored within three weeks.</p>", status="open")

if not User.objects.filter(username='admin').exists():
    User.objects.create_superuser('admin', 'info@profali.com', 'profali2024')
    print("Admin user created: admin / profali2024")
else:
    print("Admin user already exists")

print("Database seeded successfully!")
PYEOF

echo "=== Step 7: Collect static files ==="
python manage.py collectstatic --noinput

echo "=== Step 8: Write WSGI file ==="
cat > /var/www/profalithewitchdoctor_pythonanywhere_com_wsgi.py << 'WSGIEOF'
import os
import sys

path = '/home/profalithewitchdoctor/profali'
if path not in sys.path:
    sys.path.append(path)

os.environ['DJANGO_SETTINGS_MODULE'] = 'azriel.settings'

from django.core.wsgi import get_wsgi_application
application = get_wsgi_application()
WSGIEOF

echo ""
echo "========================================"
echo "  SETUP COMPLETE!"
echo "========================================"
echo "  Site: https://profalithewitchdoctor.pythonanywhere.com"
echo "  Admin: https://profalithewitchdoctor.pythonanywhere.com/admin/"
echo "  Username: admin"
echo "  Password: profali2024"
echo ""
echo "  Now click RELOAD on the Web tab!"
echo "========================================"
