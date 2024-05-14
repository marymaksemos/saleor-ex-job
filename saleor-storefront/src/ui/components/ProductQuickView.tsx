"use client";
import { useMemo, useState } from "react";
import { useParams } from "next/navigation";
import { AvailabilityMessage } from "./AvailabilityMessage";
import { ProductIntro } from "./Product/ProdcutIntero";
import { ProductVariants } from "./ProductVariants";
import { Dialog, DialogContent, DialogTrigger } from "@/components/ui/dialog";
import { formatMoney, formatMoneyRange } from "@/lib/utils";
import { type ProductListItemFragment, type ProductMedia } from "@/gql/graphql";
import { addItem } from "@/actions/addItem";
import { CartButton } from "@/components/ui/cart-button";
import { Button } from "@/components/ui/button";

interface ProductQuickViewProps {
	product: ProductListItemFragment;
}

export const ProductQuickView = ({ product }: ProductQuickViewProps) => {
	const { channel } = useParams<{ channel: string }>();
	const [open, setOpen] = useState(false);
	const [loading, setLoading] = useState(false);
	const [variantId, setVariantId] = useState(product.variants?.at(0)?.id);

	const handleAddItem = async () => {
		setLoading(true);
		await addItem({ channel, variant: variantId });
		setLoading(false);
		setOpen(false);
	};

	const isAvailable = useMemo(
		() => product.variants?.some(({ quantityAvailable }) => quantityAvailable ?? false),
		[product, product.variants],
	);

	const variant = useMemo(() => product.variants?.find(({ id }) => variantId === id), [product, variantId]);

	return (
		<Dialog open={open} onOpenChange={setOpen}>
			<DialogTrigger asChild>
				<Button>Quick View</Button>
			</DialogTrigger>
			<DialogContent className="max-w-screen-xl">
				<div className="grid gap-4 md:grid-cols-6 md:gap-8 lg:grid-cols-8">
					<div className="md:col-span-3 lg:col-span-4">
						<ProductIntro
							images={product.media as ProductMedia[]}
							thumbnails={product.mediaThumbails as ProductMedia[]}
						/>
					</div>
					<div className="md:col-span-3 lg:col-span-4">
						<h1 className="mb-4 flex-auto text-4xl font-semibold tracking-tight text-neutral-900">
							{product?.name}
						</h1>
						<p className="mb-8 text-2xl font-semibold text-blue-500" data-testid="ProductElement_Price">
							{variant?.pricing?.price?.gross
								? formatMoney(variant.pricing.price.gross.amount, variant.pricing.price.gross.currency)
								: isAvailable
									? formatMoneyRange({
											start: product?.pricing?.priceRange?.start?.gross,
											stop: product?.pricing?.priceRange?.stop?.gross,
										})
									: ""}
						</p>

						<ProductVariants product={product} onValueChange={(value) => setVariantId(value)} />
						<AvailabilityMessage
							isAvailable={product.variants?.some((variant) => variant.quantityAvailable) ?? false}
						/>
						<div className="mt-8">
							<CartButton
								onClick={handleAddItem}
								disabled={loading || !variantId || !variant?.quantityAvailable}
							>
								{loading ? "Proccessing..." : "Add To Cart"}
							</CartButton>
						</div>
					</div>
				</div>
			</DialogContent>
		</Dialog>
	);
};
